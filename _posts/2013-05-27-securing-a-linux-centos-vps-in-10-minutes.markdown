---
author: zcourts
comments: true
date: 2013-05-27 13:08:18+00:00
layout: post
slug: securing-a-linux-centos-vps-in-10-minutes
title: Securing a Linux (Centos) VPS in 10 minutes
wordpress_id: 576
categories:
- Operating Systems
tags:
- attack
- centos
- dictionary attack
- fail2ban
- linux setup
- private
- private key
- public
- public key
- secure
- ssh
- ssh authentication
- sudo
- vps
---

So, first thing's first. You've got your shiny new VPS like I have. The fact you're reading this means like me you won't allow root to ssh into it. This is good! I'm writing this because I seem to be repeating these steps quite a lot (well, once or twice every couple months) so to make sure I don't miss a step I'm writing it up to both help me and others who might need it.<!-- more -->

# Creating a user with sudo access

Start by creating a new user using:

  1. adduser courtney # create a user called courtney
  2. passwd courtney # set a password for the new user

Next create a group that you can add all users with sudo access to.

  1. groupadd sudo # create a group called sudo
  2. usermod -a -G sudo courtney # add courtney to the group called sudo

In order to let the new user execute commands with the sudo prefix the sudo group created above must be in the "sudoers" file. So modify the file using these steps.

  1. chmod +w /etc/sudoers # make the sudoers file writeable
  2. vim /etc/sudoers  
In this file find the lines that have :  
## Allows people in group wheel to run all commands  
#%wheel ALL=(ALL)    ALL  
and add the following line below it
  3. %sudo  ALL=(ALL)    ALL # where sudo is the name of the group created above
  4. chmod -w /etc/sudoers #remove the write attribute from the sudoers file

Now logout of the server as root and log back in as the user created. This user will now be able to use the sudo prefix to execute programs that need the privilege to do so.

# Generate an SSH public/private key

If you don't already have one then on your local machine, execute the following command. It will create an **id_rsa** (private key, DO NOT SHARE WITH ANYONE) and **id_rsa.pub** (public key) file in your local ~/.ssh directory.

  1. ssh-keygen

Follow the on screen instructions. It's recommend that you create a pass phrase for your key. If you don't it means anyone who has access to the file can login to the server as you without a password. There are options to use a different mode, you don't have to use RSA as the encryption algorithm but that's what I usually use so...

## Enable private key authentication on the server

Now we need to make use of the public and private key. Well, the public key. The private key stays on your local machine, the public key needs to be uploaded to the server. Do this using something such as secure copy (scp)... For example on the local machine, I use:

  1. scp ~/.ssh/id_rsa.pub courtney@my-domain.com: #including the colon, this uploads it to courtney's home directory on the server

Now switch to the server (logging in as the new user created earlier). And create the ssh dir and adjust the file location

  1. mkdir .ssh
  2. mv id_rsa.pub .ssh/authorized_keys #move the public key we just uploaded into the .ssh directory

  3. Set the permissions on the public key
    1. chown -R courtney:courtney .ssh

    2. chmod 700 .ssh

    3. chmod 600 .ssh/authorized_keys

That's almost it you can now login without a password!

## Disable password SSH login

Even though you're now more secure, you can take it a bit further by disabling password logins completely. This means that only users who have been configured to use public/private key authentication will be able to access the server. It's a good idea but does mean you'll only have access to the server only from the machine that has your private key. If like me you have a laptop and desktops, just copy the private key to the machines you want to be able to login from. Make sure only you can access those machines, or at least the private key on those machines.

Edit SSH config by opening the file:

  * sudo vim /etc/ssh/sshd_config

Set the following options in the file:

  1. PasswordAuthentication no

  2. PermitRootLogin no

Restart the SSH server with:

  1. sudo service ssh restart

# Preventing dictionary attacks

At this point you're in a decent state. But to make things even better you can install a program known as fail2ban. It prevents dictionary attacks on your VPS by detecting multiple failed login attempts from the same IP and can do things like creating temporary firefall rules that can block traffic from an attacker's IP, attempted logins can be monitored on various protocols such as SSH, SMTP, HTTP etc but by default it only monitors SSH.

Install it using:

  1. sudo yum install fail2ban

You can change the default settings by editing **/etc/fail2ban/jail.local.**

That's a pretty good start. The next steps to making this even more secure is setting up the firewall and locking down ports. But that's for another post. Hope this helps!

P.S to add multiple SSH keys for one user see http://www.cyberciti.biz/tips/linux-multiple-ssh-key-based-authentication.html
