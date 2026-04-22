# Day 72 – Jenkins Parameterized Builds


## Task/Problem Statement

A new DevOps Engineer has joined the team and he will be assigned some Jenkins related tasks. Before that, the team wanted to test a simple parameterized job to understand basic functionality of parameterized builds. He is given a simple parameterized job to build in Jenkins. Please find more details below:



Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.


1. Create a parameterized job which should be named as parameterized-job


2. Add a string parameter named Stage; its default value should be Build.


3. Add a choice parameter named env; its choices should be Development, Staging and Production.


4. Configure job to execute a shell command, which should echo both parameter values (you are passing in the job).


5. Build the Jenkins job at least once with choice parameter value Staging to make sure it passes.

---

##  Task Summary

This task demonstrates how to create and execute a **parameterized job in Jenkins**, allowing dynamic input at build time. The objective is to validate how Jenkins handles user-defined parameters (string and choice) and passes them into a build step for execution.



##  Implementation Steps

### 1. Access Jenkins

* Open Jenkins UI from the top navigation bar
* Login with:

  * **Username:** `admin`
  * **Password:** `Adm!n321`



### 2. Create a New Job

* Click **New Item**
* Enter name: `parameterized-job`
* Select **Freestyle Project**
* Click **OK**


### 3. Enable Parameterization

* Scroll to **General** section
* Check **This project is parameterized**


### 4. Add Parameters

#### ➤ String Parameter

* Click **Add Parameter → String Parameter**
* Name: `Stage`
* Default Value: `Build`

#### ➤ Choice Parameter

* Click **Add Parameter → Choice Parameter**
* Name: `env`
* Choices:

  ```
  Development
  Staging
  Production
  ```


### 5. Add Build Step

* Scroll to **Build** section

* Click **Add build step → Execute shell**

* Add the following command:

```bash
echo "Stage is: $Stage"
echo "Environment is: $env"
```


### 6. Save Job

* Click **Save**


### 7. Trigger Build with Parameters

* Click **Build with Parameters**
* Set:

  * `Stage` → leave default or modify
  * `env` → select **Staging**
* Click **Build**



### 8. Validate Output

* Open **Build History → Console Output**
* Confirm output shows:

```bash
Stage is: Build
Environment is: Staging
```

---

##  Expected Outcome

* Job runs successfully without errors
* Parameters are correctly injected into the shell environment
* Console output reflects selected values

![parameterized build](./images/parameterized%20job.png)
![Console success](./images/Console%20success.png)

---

##  Key Takeaways

* Parameterized jobs enable **dynamic and reusable pipelines**
* Jenkins exposes parameters as **environment variables** in build steps
* Choice parameters help enforce **controlled deployment environments**
* This pattern is foundational for **CI/CD pipelines across dev, staging, and production**

