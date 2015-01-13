---
author: zcourts
comments: true
date: 2011-02-21 00:40:38+00:00
layout: post
slug: creating-a-php-url-mapper-to-parse-fancy-urls-and-query-strings
title: Creating a PHP URL mapper to parse fancy URLs and query strings
wordpress_id: 70
categories:
- PHP
---

I've been working on a PHP framework for my group over the last few weeks. We were required to build almost everything from scratch so using another framework such as [Codeignitor](http://www.codeignitor.com) was not an option.

The URL mapper basically breaks up a URL into chunks and allows you to programatically add variables to the query string or get the value of a variable in the URL of the current page request.

Admittedly it's not perfect and could do with improvements but it works well for our use case and we don't have time to spend making it any better.

The first bit to this is to use .htaccess file and route all requests to index.php - Only requests that are not for a real file or directory is mapped to idnex.php, so for example if the file view.php exists then the request will go to that file. This .htaccess code is actually the original from [Wordpress](http://www.wordpress.org).

```php
# BEGIN ROUTING
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END ROUTING
```

The code for the PHP class, URI is as follows:

```php
<?php

class URI {

    private $uri;
    private $uriParts = array();
    private $data;
    private $isPrettyUrl = true;
    private $currentURI;
    private $currentURL;
    private $scheme;
    private $host;
    private $port;
    private $user;
    private $pass;
    private $path;
    private $query;
    private $fragment;

    public function __construct() {
        $this->currentURI = parse_url($_SERVER["SCRIPT_URI"]);
        $this->port = $_SERVER["SERVER_PORT"];
        $this->host = $_SERVER["SERVER_NAME"];
        $this->scheme = $this->currentURI["scheme"];
        $this->getPath();
        //build the current url before anything is done
        $this->currentURL= $this->buildURL();

    }
    /**
     *
     * @return string The full url  of the current page is returned
     */
    public function getCurrentURL(){
        return $this->currentURL;
    }
    /**
     *
     * @param string $varName the key to which a value must be returned
     * @return string the value of the query parameter is returned e.g
     * if url is path/name and @param $varName is path then "name" is returned
     * returns null if the requested var does not exist
     */
    public function getVar($varName) {
        if (isset($this->data[$varName])) {
            return $this->data[$varName];
        } else {
            return NULL;
        }
    }

    /**
     *
     * @param string $varName the name of the key you wish to set a value to
     * this can be an existing key, in which case the old value is overriden
     * @param string $value
     */
    public function setVar($varName, $value) {
        $this->data[$varName] = $value;
    }

    /**
     * Only call this method if you do not want to include all the existing
     * varaibles/data from the current url, in which case you must
     * use setVar to set the query strign parameters you need
     */
    public function emptyQueryString() {
        $this->data = NULL;
    }
    /**
     *
     * @return string returns the base domain without trailing slash
     */
    public function getHost(){
        return $this->scheme . "://" . $this->host;
    }
    public function buildURL() {
        $base = $this->scheme . "://" . $this->host . "/";
        $q = "";
        foreach ($this->data as $key => $val) {
            if ($this->isPrettyUrl == true) {
                //if key is not empty
                if(!empty($key))
                $q.=$key . "/" . $val . "/";
            } else {
                //if empty we need a ?
                if (empty($q)) {
                    $q.="?" . $key . "=" . $val;
                } else {
                    $q.="&" . $key . "=" . $val;
                }
            }
        }
        return $base . $q;
    }

    private function getPath() {
        // Get the URL path...everything after the domain name
        $this->uri = $_SERVER['REQUEST_URI'];
        if (preg_match('/\/index\.php\?/', $this->uri)) {
            //only case where we can say fo sure that its not a pretty url
            $this->isPrettyUrl = false;
            $this->parseQueryString();
        } else {
            // IF ? is found at an position >1 then still parse
            //can be found at domain.com/? or domain.com/path? or domain.com/path/?
            if (strpos($this->uri, "?") >1) {
                //remove the query string first i.e path/?some=value
                $parts = split('\?', $this->uri);

                //set new uri for parsequerystring to operate on
                $this->uri = $parts[1];
                $this->parseQueryString(); //parse query string and join data

                //now have idx 0 = path and idx 1 = some=value
                //set new uri for parse to operate on
                $this->uri = $parts[0];
                $this->parse();

            } else {
                $this->parse();
            }
        }
    }

    private function parseQueryString() {
        //parse query string
        $this->uriParts = parse_url($this->uri);
        $parts = "";
        if (isset($this->uriParts["query"])) {
            //parse the query string and stick its values into data
            parse_str($this->uriParts["query"], $parts);
        } else {
            parse_str($this->uriParts["path"], $parts);
        }
        //merge the query string with anything already in data
        $this->data = array_merge((array) $parts, (array) $this->data);
    }

    /**
     * if directory style url then parse parts
     */
    private function parse() {
        //// Split URL into array
        $this->uriParts = explode('/', $this->uri);
        //first element is always empty so remove it
        array_shift($this->uriParts);
        //domain.com/key/value is the format
        //every second part is a value and the first is the key
        $i = 0; //counter i, when =1 its a value when =0 its a key
        //on second iteration
        $key = ""; //need to store the key on the first iteration to access data array
        foreach ($this->uriParts as $part) {
            if ($i == 0) {
                //if i==0 then its a key so set it to an empty string
                $this->data[$part] = "";
                $key = $part;
                $i++; //only increment if i==0
            } else {
                //need to make first letter upper case if the key is view
                if ($key == "view") {
                    $this->data[$key] = ucfirst($part);
                } else {
                    $this->data[$key] = $part;
                }
                //lets make sure we destroy this key since the value is now assigned
                unset($key);
                $i = 0; //reset to get next key
            }
        }
    }

}

?>

```

Example usage:

```php
 $url=new URI();
//assuming the query string has view=somevalue
        print $url->getVar("view");
//change the value of view to home - override existing var
        $url->setVar("view", "home");
//add a new var and assign testing
        $url->setVar("test", "testing");
//build the url with any changes
    print $url->buildURL();

```


The URL generated will be in the form

http://www.domain.com/view/home/test/testing
If the ckass determines that you're not using fancy URLs then the generated URL will be

http://www.domain.com/?view=home&test=testing

It determines if you're using fancy URLs by checking to see if the current URL starts off in the form http://www.domain.com/? or if index.php? is in the url which mean your URL is in the form http://www.domain.com/index.php?some=var...

It also handles a combination of fancy URLs and normal query strings but only if the query string is tacked on to the end of the URL in the form
http://www.domain.com/home/view/test/testing?query=string&page=1

In this case, it still assumes fancy URL is the format and when buildURL() is called it generates a fancy URL converting the query string into part of the fancy URL.
