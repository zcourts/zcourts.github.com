---
author: zcourts
comments: true
date: 2011-01-28 08:38:32+00:00
layout: post
slug: building-a-simple-java-none-blocking-server
title: Building a simple Java none-blocking server
wordpress_id: 45
categories:
- Java
---

[O'reily NIO tutorial](http://tim.oreilly.com/pub/a/onjava/2002/09/04/nio.html?page=1)(1)


I found myself in need of a way to connect to [Cassandra 0.7](http://cassandra.apache.org)
Existing clients are either unreliable or none existent. Being a fan of the
Java [hector client](https://github.com/rantav/hector) (which is undoubtedly the best I've found) I decided to write a language independent
"wrapper" around the hector API.

I'll cover the client a different blog post, but I wanted to write a socket server that'll handle multiple users at the same time.
I t turns out using the raw [Java NIO](http://java.sun.com/developer/technicalArticles/javase/nio/) package would end taking the attention away from writing the Cassandra "client" so in the end
I used the server library, [Netty](http://www.jboss.org/netty/)... Below is the code I had up to the point I moved to Netty.
It allows multiple connections on the same socket but the requests are still processed sequentially which means, if a single request
hangs then all subsequent requests will hang until the connections start to timeout or the server is overloaded and turns over.

[code lang="java"]
package info.crlog.server;

import info.crlog.interfaces.Constants;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.util.Iterator;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *based on http://tim.oreilly.com/pub/a/onjava/2002/09/04/nio.html?page=2
 * @author Courtney
 */
public class Server implements Constants {

    private int port = 9969;
    private String host = "127.0.0.1";

    public static void main(String[] args) {
        Server serv = new Server();
        serv.init();
    }

    private void init() {
        try {
            // Create the server socket channel
            ServerSocketChannel server = ServerSocketChannel.open();
            // nonblocking I/O
            server.configureBlocking(false);
            // host-port
            server.socket().bind(new InetSocketAddress(host, port));
            System.out.println("Server connected on " + host + ":" + port);
            // Create the selector
            Selector selector = Selector.open();
            // Recording server to selector (type OP_ACCEPT)
            server.register(selector, SelectionKey.OP_ACCEPT);
            // Infinite server loop
            for (;;) {
                // Waiting for events
                selector.select();
                // Get keys
                Set keys = selector.selectedKeys();
                Iterator i = keys.iterator();
                // For each keys...
                while (i.hasNext()) {
                    SelectionKey key = (SelectionKey) i.next();
                    // Remove the current key
                    i.remove();
                    //see if client is requesting connection
                    if (acceptConn(key, server, selector)) {
                        continue;
                    }

                    // then the server is ready to read
                    if (performIO(key)) {
                        continue;
                    }
                }
            }
        } catch (IOException ex) {
            Logger.getLogger(Server.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private boolean performIO(SelectionKey key) throws IOException {
        if (key.isReadable()) {
            SocketChannel client = (SocketChannel) key.channel();
            // Read byte coming from the client
            int BUFFER_SIZE = 32;
            ByteBuffer buffer = ByteBuffer.allocate(BUFFER_SIZE);
            try {
                client.read(buffer);
            } catch (Exception e) {
                // client is no longer active
                e.printStackTrace();
                return true;
            }
            buffer.flip();
            Charset charset = Charset.forName("ISO-8859-1");
            CharsetDecoder decoder = charset.newDecoder();
            CharBuffer charBuffer = decoder.decode(buffer);
            Handler dataHandler = new Handler();
            client.write(ByteBuffer.wrap(dataHandler.processInput(charBuffer.toString()).getBytes()));
            client.socket().close();
            return true;
        }
        return false;
    }

    private boolean acceptConn(SelectionKey key, ServerSocketChannel server, Selector selector) throws IOException {
        // if isAccetable = true
        // then a client required a connection
        if (key.isAcceptable()) {
            // get client socket channel
            SocketChannel client = server.accept();
            // Non Blocking I/O
            client.configureBlocking(false);
            // recording to the selector (reading)
            client.register(selector, SelectionKey.OP_READ);
            return true;
        }
        return false;
    }
}
[/code]

There are comments included to help you follow, the page cited below has an excellent tutorial and indept description of how
to get this all done so if you're having problems making it work, ask in the comments or have a read through the tutorial linked
below.
Further reading:
[1][Introducing Nonblocking Sockets](http://tim.oreilly.com/pub/a/onjava/2002/09/04/nio.html) by [Giuseppe Naccarato](http://tim.oreilly.com/pub/au/1021)
