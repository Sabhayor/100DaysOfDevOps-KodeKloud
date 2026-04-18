# Day 69 - Install Jenkins Plugins (Git & GitLab)

## Task/Requirement

The Nautilus DevOps team has recently setup a Jenkins server, which they want to use for some CI/CD jobs. Before that they want to install some plugins which will be used in most of the jobs. Please find below more details about the task



1. Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.


2. Once logged in, install the Git and GitLab plugins. You may need to restart Jenkins to complete the plugin installation; if required, opt to Restart Jenkins when installation is complete and no jobs are running on the plugin installation/update page (Update Centre).

Note:

- After restarting Jenkins, wait for the login page to reappear before proceeding.



## Task Summary

The Nautilus DevOps team provisioned a Jenkins server to support CI/CD pipelines. Before onboarding jobs, the environment needed essential integrations. This task focuses on installing the **Git** and **GitLab** plugins via the Jenkins UI to enable source control connectivity and pipeline automation.

---

## Objective

* Access Jenkins UI securely
* Install required plugins:

  * Git Plugin
  * GitLab Plugin
* Restart Jenkins safely to apply changes

---

## Step-by-Step Implementation

### 1. Access Jenkins Dashboard

* Open Jenkins from the top navigation bar
* Login with:

  * **Username:** `admin`
  * **Password:** `Adm!n321`

---

### 2. Navigate to Plugin Manager

* From the dashboard:
  **Manage Jenkins → Plugins (or Manage Plugins)**

---

### 3. Install Required Plugins

* Go to the **Available Plugins** tab
* Search and select:

  * `Git Plugin`
  * `GitLab Plugin`
* Click:
  **Install without restart** *(or select restart option if prompted)*

---

### 4. Restart Jenkins

* If prompted, select:
  **"Restart Jenkins when installation is complete and no jobs are running"**

* Wait until:

  * Jenkins restarts fully
  * Login page becomes accessible again

---

### 5. Verify Installation

* Navigate back to:
  **Manage Jenkins → Plugins → Installed Plugins**
* Confirm both plugins are listed

---

## Key Considerations

* Ensure no active jobs are running before restart
* Plugin installation may take a few minutes depending on dependencies
* Always verify plugin status post-restart

---

## Outcome

Jenkins is now equipped with Git and GitLab integrations, enabling seamless repository access and CI/CD pipeline execution—aligning the setup with production-ready DevOps workflows.

![Jenkins plugin](./images/git%20and%20gitlab.png)

---

##  Key Takeaways

* Jenkins plugins extend core functionality and are critical for integrations
* Safe restart practices prevent pipeline disruption
* Git-based plugins are foundational for most CI/CD pipelines

