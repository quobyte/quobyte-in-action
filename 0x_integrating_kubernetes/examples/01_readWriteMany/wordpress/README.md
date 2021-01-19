

# Wordpress Deployment

* A pod with a wordpress installation inside a volume.

* A stateful mysql service

## Webapp (Wordpress)

The deployment of this component can be done using a kubernetes *deployment*. This deployment should be exposed as a kubernetes *service* which also provides loadbalancing capabilities. With these two building blocks the service can exist as a long lasting object with the possibility to change Webapp (Wordpress) rapidly and with nearly no downtime.

## Database (MySQL)

To deploy components that handle state (in this case database data that should survive a re-deployment) we suggest to use *stateful sets* in kubernetes.
Additionally we strongly suggest to store persistent data (/var/lib/mysql in this case) in a *persistent volume*. 
This persistent volume can be accessed using *persistent volume claims*.
The mysql-service should also be announced/ exposed as a kubernetes *service*

## Connecting Webapp (Wordpress) and Database (MySQL)
To connect both components we recommend to use kubernetes secrets to be injected into server and client. This ensures that clients can connect to services using environment variables that are strongly bound to the specified scope.

The single steps neccessary are demonstrated using code snippets in a numbered order. 

You can deploy the whole setup using the following command:

``` kubectl apply -f . ``` in the files directory.

