# AI To-Do List

A simple web application that combines task management with Generative AI.

## Project Overview

AI To-Do List allows users to create and delete tasks and use Generative AI to break a task into smaller, practical steps.

The main AI feature is **AI Break Down**.

For example, a user can enter:

> Prepare my project presentation

The application sends the task to the backend, which asks Google Gemini to generate 3–5 clear steps. The result is then displayed in the web browser.

## Main Features

- Add a task
- Delete a task
- Break down a task using Generative AI
- Simple web interface
- Flask backend API
- AWS EC2 deployment
- Nginx web server

## Technologies

### Frontend

- HTML
- CSS
- JavaScript

### Backend

- Python
- Flask
- Flask-CORS
- Google GenAI SDK
- Gunicorn
- python-dotenv

### AWS / Infrastructure

- Amazon EC2
- Amazon Linux 2023
- Nginx
- Terraform
- systemd
- SSH

### Version Control

- Git
- GitHub

## Architecture

```text
User Browser
     |
     v
AWS EC2
     |
     v
Nginx :80
     |
     +----------------------+
     |                      |
     v                      v
Frontend               /api/*
HTML/CSS/JS                |
                            v
                       Gunicorn :8000
                            |
                            v
                       Flask Backend
                            |
                            v
                       Google Gemini API
```

## How the AI Feature Works

1. The user enters a task.
2. The user clicks **AI Break Down**.
3. JavaScript sends the task to `/api/breakdown`.
4. Flask receives the task.
5. The backend sends a prompt to Google Gemini.
6. Gemini generates 3–5 practical steps.
7. Flask returns the response.
8. The frontend displays the generated steps.

## API Endpoints

### Health Check

```http
GET /api/health
```

Used to verify that the backend is running.

### AI Breakdown

```http
POST /api/breakdown
```

Example request:

```json
{
  "task": "Prepare my project presentation"
}
```

## AWS Deployment

The application was deployed to an Amazon Linux 2023 EC2 instance in the AWS region:

```text
eu-north-1
```

The EC2 instance uses:

```text
t3.micro
```

A dedicated security group was created for the project.

The security group allows SSH access from the development machine's public IP and HTTP access on port 80.

Nginx serves the frontend and forwards `/api/` requests to the Flask backend running through Gunicorn.

The backend is managed by a systemd service called:

```text
ai-todo-list.service
```

## Terraform

Terraform was used to provision the project's AWS infrastructure.

The repository contains:

```text
terraform/
├── main.tf
└── providers.tf
```

Terraform provisions the EC2 infrastructure and the project's security group.

The actual application deployment and server configuration were completed manually over SSH after the infrastructure was created.

Therefore, the current Terraform configuration does not fully automate application deployment.

## Project Structure

```text
ai-todo-list/
├── backend/
│   ├── app.py
│   ├── requirements.txt
│   └── .gitignore
│
├── frontend/
│   ├── index.html
│   ├── script.js
│   └── style.css
│
├── terraform/
│   ├── main.tf
│   └── providers.tf
│
├── documentation/
├── .gitignore
└── README.md
```

## Local Development

The application was developed and tested locally in WSL Ubuntu.

The backend uses a Python virtual environment.

The Gemini API key is stored locally in:

```text
backend/.env
```

The `.env` file is excluded from Git using `.gitignore`.

## Security

The Gemini API key is stored in an environment file and is not included in the GitHub repository.

The project's SSH access is restricted by the security-group rule.

Private SSH keys, passwords, and API secrets are not stored in the repository.

## Testing

The application was tested locally and after deployment to AWS.

Tests included:

- Backend health check
- Nginx configuration test
- Nginx service check
- Gunicorn service check
- Public frontend access
- Public API access
- Real Gemini API request
- Browser test of the AI Break Down function

The deployed application successfully generated AI task breakdowns in the browser.

## GitHub

Public repository:

https://github.com/marmo2see/ai-todo-list

Main branch:

```text
main
```

Initial commit:

```text
ef47ef8 Initial commit for AI To-Do List
```

Sensitive and local files are excluded from Git, including:

```text
backend/.env
backend/venv/
terraform/.terraform/
terraform/*.tfstate
terraform/*.tfplan
```

## Learning Outcomes

This project gave us practical experience with:

- Generative AI integration
- API integration
- Web development
- AWS EC2
- Linux administration
- Nginx
- Gunicorn
- systemd
- Terraform
- SSH
- Git
- GitHub

## Future Improvements

Possible future improvements include:

- Persistent task storage
- User accounts
- More AI features
- HTTPS and a domain name
- Fully automated application deployment
- Improved frontend design
- Additional validation and error handling