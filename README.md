# Reverse Tunnel App for Cloud Foundry

The code in this repository can be used to setup a reverse tunnel to your cloud foundry environment. This is useful in situation where you are working with a remote web service that only allows your cloud foundry IP addresses to access the service. If you want to do development on your local machine you normally wouldn't be able to access the remote service, because your local IP is not whitelisted for the service. Using the reverse tunnel app in this repo you can forward the requests to your cloud foundry proxy app which accesses the service for you.

## Prerequisites

* You have logged into your cloud foundry using the `cf login` command.

## Building and setup

Execute the following command to start building and pushing the app to the cloud-foundry environment:
```
make push-app
```

Onces the app is successfully pushed, enable ssh for the app using the following command:
```
make cf-enable-ssh
```
This will enable ssh access, which is needed to setup the tunnel. In order to activate this, the app is restarted.

## Running the reverse tunnel...

... is done using the following command:

```
make start-reverse-tunnel
```

This command establishes the required port forwards and drops into a shell inside the app container. Check the output of the command for something like "_appname_ is using port _port-number_". Make note of the port-number, which is usually 8080.

## Verify that it's working

In another terminal, call
```
curl ifconfig.net
```
to check your "regular" local ip address. This is the address without going through the reverse tunnel. (In the shell you could run `curl ifconfig.net` in order to display the external IP of your cloud foundry app container.)

In order to activate the reverse tunnel, you have to set the `HTTP[S]_PROXY` environment variable(s) to "http://localhost:8080". (If the previous command showed another port number use that.)

The command
```
HTTPS_PROXY=http://localhost:8080 \
curl -s https://ifconfig.net
```
should now return the external IP address of your app container, as if you would have called this command from inside the container. The remote service (here: ifconfig.net) "thinks" the request comes from the cloud-foundry container. Any IP whitelisting rules would now applied on that address instead of on your localhost's one. You're are now ready to access your IP-restricted service from your localhost!