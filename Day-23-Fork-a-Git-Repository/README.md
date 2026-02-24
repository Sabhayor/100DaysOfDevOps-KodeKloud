# Day 23 – Fork a Git Repository (KodeKloud 100DaysOfDevOps)

## Task / Objective
Fork the existing repository `sarah/story-blog` into the `jon` account using the Git Server UI web interface, enabling Jon to begin independent development work.

---

## Steps Performed

### 1. Access the Git Server
- Clicked the **Gitea UI** button from the top navigation bar.
- Redirected to the Gitea login page.

### 2. Authenticate as Jon
- Logged in with:
  - **Username:** `jon`
  - **Password:** `Jon_pass123`
- Successfully accessed Jon’s dashboard.

### 3. Locate the Repository
- Searched for and opened:
  - `sarah/story-blog`
- Verified repository ownership and contents.

### 4. Fork the Repository
- Clicked the **Fork** button.
- Selected the `jon` account as the fork destination.
- Confirmed the action.

---

## Expected Outcome
- A new repository is created under Jon’s account:
  - `jon/story-blog`
- The fork is independent of the original repository.
- Jon now has full control to:
  - Create branches  
  - Modify code  
  - Push changes  
  - Submit pull requests  


![forked_repo](./images/forked%20repo.png)
---

## Key Learnings
- Forking creates an independent copy of a repository under a different user namespace.
- This workflow enables isolated feature development without affecting the upstream repository.
- It supports structured collaboration models commonly used in production and open-source environments.
- Understanding fork-based workflows is critical for distributed version control and DevOps team operations.

