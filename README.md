Tube - old fashion port forwarding
=========================================

Tube is a tool that forward a local port to a remote server using only the
terminal. Meaning: no need for the server to have a reachable network interface
at all, as long as you can have a shell, you can connect!

Wait! How would I get a shell if the server has no network device?

It could be that the server you are trying to reach is jailed/containerized in
such a way that your service cannot bind any network interface visible from the
outside, yet you can execute a shell to that VM (think docker container with
no published ports).

Or it could be that to access your server you need to hop from one location to
another, each requiring a manual (interactive) authentication process.

In those cases, tube can help. Here is what it does:

```shell
# Run tube locally, specifying that it's the tunnel _in_put
# and that you want to forward port 8080:
your_machine $ tube in 8080

# tube will create a pseudo-terminal, and fork /bin/sh in it:
$ echo 'hello world!'
hello world!

# Then you can start digging to your remote service:
$ ssh john.doe@remote-server1.net
server1 $ ssh john.doe@remote-server2.net
server2 $ docker exec -ti container /bin/bash
container $ echo 'Reached the destination!'
Reached the destination!

# Now tube is almost ready to accept local connections and
# forward the traffic (tubencoded) to the terminal up to here.
# But we need some program running here to read them from stdin
# and connect to localhost for the final leg of the journey.
# tubedecode piped into nc or netcat could do that, but that's not
# very convenient.
# tube can do this of course! but...
container $ tube
tube: command not found

# Here is the trick: tube can send itself (tubencoded) if you
# press the magic key sequence(which is !!>). But wait, first disable terminal echo:
container $ stty -echo; tubedecode; stty echo
# tubedecode is waiting; now press the magic sequence: 
!!>
Done.
container $ ls
tube

# Magic! Now run tube, specifying that it is now the _out_put,
# and which port from localhost to connect to:
container $ ./tube out 80
Peered! Forwarding port...

# Done! You can now connect from your laptop into "localhost:8080" to
# reach this server (as if you had done ssh -L 8080:localhost:80).
```

