<p align="center">
  <a href="https://www.gatsbyjs.org">
    <img alt="Gatsby" src="https://www.gatsbyjs.org/monogram.svg" width="60" />
  </a>
</p>
<h1 align="center">
  Gatsby + Docker, Kubernetes & Istio
</h1>

## 💫 Deploy using Docker, Kubernetes & Istio

### Tools Required
1. Docker Desktop for Mac / Windows
2. Download Istio from https://github.com/istio/istio/releases/ 

### Local Environment Setup
1. Enable Kubernetes on Docker Desktop
2. Add the Istio **/bin** folder to the $PATH

### UI Deployment Instructions

#### 1. Create the docker image

```shell
# 'Install the dependencies'
npm install

# 'Create a Gatsby application build'
npm run build 

# 'Copy the build contents into a docker image'
docker build -t gatsby-hello:v1 -f local.Dockerfile . 
```

#### 2. Run the docker image as a container
```shell
# 'Creates a docker container using the docker image'
docker run --name gatsby-hello-container1 -d -p 8000:9000 gatsby-hello:v1
```
The above command may or may not create a container inside the Kubernetes cluster, depending whether it is enabled in the Docker for Desktop. You may now access the application at http://localhost:8000

#### 3. Deploy the docker image created in Step #1 to the Kubernetes cluster
```shell
# 'Create a Kubernetes Pod'
kubectl apply -f kube-platform-deployment.yaml

# 'View the newly created Pod'
kubectl get pod

# 'Stream logs from a container in a pod'
kubectl logs <name-of-pod> -c <name-of-container> -f

# 'Shows a lis of deployed services'
kubectl get service

# 'You may also delete the Services & Deployment'
kubectl delete -f kube-platform-deployment.yaml
```
You may now access the application at http://localhost:30001. This doesn't make use of the Istio service mesh to routing traffic to the Container. Instead it uses the NodePort service. See [kube-platform-deployment.yaml](kube-platform-deploymwnt.yaml) 

At this point, even though we haven't run any specific commands for Istio, the pod created contains an Istio Envoy Proxy. This happens because of the Automatic Sidecar Injection configuration; which is default Out-of-the-box. This can be verified by running the following commands.
```shell
# 'Shows how containers per Pod. Expected value is 2/2'
kubectl get pods

# 'Shows the containers and other details in a Pod'
kubectl describe pod <name-of-the-pod>
```

#### 4. Deploy the docker image created in Step #1 to the Kubernetes cluster and route traffic using Istio

1. Create Istio Gateway & Virtual Service
```shell
kubectl apply -k istio-gateway-and-virtual-service.yaml

# 'View the newly created gateway'
kubectl get gateway

# 'View the newly created gateway details'
kubectl describe gateway <name-of-the-gateway>



# 'You may also delete the Gateway & Virtual Service'
kubectl delete -f istio-gateway-and-virtual-service.yaml
```

2. Determine Ingress Host / Port & access the application
```shell
# 'Ensure Istio Gateway is using an External Load Balancer. EXTERNAL-IP column should not be empty.'
kubectl get svc istio-ingressgateway -n istio-system

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')

# 'Optional'
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
```
This typically resolves to http://localhost:80/. The final URL to access your application is http://localhost/default/gatsby-hello/

## 🚀 Quick start

1.  **Start developing.**

    Navigate into your new site’s directory and start it up.

    ```shell
    cd my-hello-world-starter/
    gatsby develop
    ```

1.  **Open the source code and start editing!**

    Your site is now running at `http://localhost:8000`!

    _Note: You'll also see a second link: _`http://localhost:8000/___graphql`_. This is a tool you can use to experiment with querying your data. Learn more about using this tool in the [Gatsby tutorial](https://www.gatsbyjs.org/tutorial/part-five/#introducing-graphiql)._

    Open the `my-hello-world-starter` directory in your code editor of choice and edit `src/pages/index.js`. Save your changes and the browser will update in real time!

## 🧐 What's inside the Gatsby App?

A quick look at the top-level files and directories you'll see in a Gatsby project.

    .
    ├── node_modules
    ├── src
    ├── .gitignore
    ├── .prettierrc
    ├── gatsby-browser.js
    ├── gatsby-config.js
    ├── gatsby-node.js
    ├── gatsby-ssr.js
    ├── LICENSE
    ├── package-lock.json
    ├── package.json
    └── README.md

1.  **`/node_modules`**: This directory contains all of the modules of code that your project depends on (npm packages) are automatically installed.

2.  **`/src`**: This directory will contain all of the code related to what you will see on the front-end of your site (what you see in the browser) such as your site header or a page template. `src` is a convention for “source code”.

3.  **`.gitignore`**: This file tells git which files it should not track / not maintain a version history for.

4.  **`.prettierrc`**: This is a configuration file for [Prettier](https://prettier.io/). Prettier is a tool to help keep the formatting of your code consistent.

5.  **`gatsby-browser.js`**: This file is where Gatsby expects to find any usage of the [Gatsby browser APIs](https://www.gatsbyjs.org/docs/browser-apis/) (if any). These allow customization/extension of default Gatsby settings affecting the browser.

6.  **`gatsby-config.js`**: This is the main configuration file for a Gatsby site. This is where you can specify information about your site (metadata) like the site title and description, which Gatsby plugins you’d like to include, etc. (Check out the [config docs](https://www.gatsbyjs.org/docs/gatsby-config/) for more detail).

7.  **`gatsby-node.js`**: This file is where Gatsby expects to find any usage of the [Gatsby Node APIs](https://www.gatsbyjs.org/docs/node-apis/) (if any). These allow customization/extension of default Gatsby settings affecting pieces of the site build process.

8.  **`gatsby-ssr.js`**: This file is where Gatsby expects to find any usage of the [Gatsby server-side rendering APIs](https://www.gatsbyjs.org/docs/ssr-apis/) (if any). These allow customization of default Gatsby settings affecting server-side rendering.

9.  **`LICENSE`**: This Gatsby starter is licensed under the 0BSD license. This means that you can see this file as a placeholder and replace it with your own license.

10. **`package-lock.json`** (See `package.json` below, first). This is an automatically generated file based on the exact versions of your npm dependencies that were installed for your project. **(You won’t change this file directly).**

11. **`package.json`**: A manifest file for Node.js projects, which includes things like metadata (the project’s name, author, etc). This manifest is how npm knows which packages to install for your project.

12. **`README.md`**: A text file containing useful reference information about your project.

## 🎓 Learning Gatsby

Looking for more guidance? Full documentation for Gatsby lives [on the website](https://www.gatsbyjs.org/). Here are some places to start:

- **For most developers, we recommend starting with our [in-depth tutorial for creating a site with Gatsby](https://www.gatsbyjs.org/tutorial/).** It starts with zero assumptions about your level of ability and walks through every step of the process.

- **To dive straight into code samples, head [to our documentation](https://www.gatsbyjs.org/docs/).** In particular, check out the _Guides_, _API Reference_, and _Advanced Tutorials_ sections in the sidebar.

## References

### Kubernetes
1. https://docs.docker.com/get-started/kube-deploy/
2. https://kubectl.docs.kubernetes.io/pages/container_debugging/container_logs.html

### Istio
1. https://istio.io/latest/docs/setup/getting-started/
2. https://istio.io/v1.0/docs/setup/kubernetes/sidecar-injection/#automatic-sidecar-injection
3. https://istio.io/v1.0/docs/tasks/traffic-management/ingress/#determining-the-ingress-ip-and-ports
4. https://istio-releases.github.io/v0.1/docs/tasks/integrating-services-into-istio.html
5. https://istio.io/latest/docs/reference/config/networking/virtual-service/