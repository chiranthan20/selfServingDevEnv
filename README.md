# Self Serving Developer Environment System
This Repo contains Design Description of our Automated System which Provisions and provides access of Development Environment to the User.


**About Project:**
This is a pipeline system setup which provisions automated Development environments upon request from the user. This serves three kind of Developer request.
1) Bare VMs Provsioning.
2) Host Stateless DevApps on Azure Container Instance.
3) Configure custom VM images and provsion VM out of it.


<img width="1770" height="1170" alt="DEVENV drawio" src="https://github.com/user-attachments/assets/d826fa56-1cd0-4796-b4ed-4c485a4fd360" />

**High Level System Design:**
The Entire System is designed using Azure DevOps Pipeline Templates which also acts as UI for Developer to get his/her Dev Environment created. Terraform, Ansible, Packer are some other tools used. Terraform handles infra provisioning in Azure while ansible and packer help in configuring custom VM images.
There are three Pipelines as part of this project:

1) Main Pipeline which provision the actual required Dev Environment.
2) A Custom OS provision pipeline which configures and stores a Custom VM image in azure compute gallery.
3) A Docker Build pipeline which builds and pushes a app specific Docker image to azure container registry.

As mentioned above we have 3 ways of provisioning of Dev Environment. Each has a definite use case. The user has to select one option and submit the right parameter value during pipelin run. 

<img width="483" height="782" alt="image" src="https://github.com/user-attachments/assets/37a35378-82e6-4d59-a88d-3b2357dc9681" />

- DevOps Engineer maintains the config of Custom VM images based on product request. And Developer needs to write Dockerfile if he wants any stateless application, Docker Build Pipeline is enabled with CI so when there is a new change the pipeline runs and creates a new Image in Registry which can later be used inside ACI.
- When a User triggers pipeline by selecting bareWindowsVM option, a VM is created with windows OS and a role "Virtual Machine Administrator Login" is assigned to the person who had triggered the pipeline this maintaining RBAC.




