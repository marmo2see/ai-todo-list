import os

from dotenv import load_dotenv
from flask import Flask, jsonify, request
from flask_cors import CORS
from google import genai

load_dotenv(dotenv_path=".env")

app = Flask(__name__)
CORS(app)

api_key = os.getenv("GEMINI_API_KEY")

if not api_key:
    raise RuntimeError("GEMINI_API_KEY is not configured.")

client = genai.Client(api_key=api_key)


@app.route("/api/health", methods=["GET"])
def health():
    return jsonify({
        "status": "ok",
        "message": "AI To-Do List backend is running"
    })


@app.route("/api/breakdown", methods=["POST"])
def breakdown():
    data = request.get_json(silent=True) or {}
    task = data.get("task", "").strip()

    if not task:
        return jsonify({
            "status": "error",
            "message": "Please provide a task."
        }), 400

    prompt = f"""
You are helping a user plan a simple to-do task.

Break the task into 3 to 5 clear, practical steps.

Rules:
- Focus only on the task provided.
- Do not invent AWS services, cloud architectures, tools, or technologies unless the task explicitly mentions them.
- Keep the steps simple and suitable for a beginner.
- Return only numbered steps.
- Do not add an introduction or conclusion.

Task:
{task}
"""

    try:
        response = client.models.generate_content(
            model="gemini-3.5-flash-lite",
            contents=prompt
        )

        return jsonify({
            "status": "success",
            "task": task,
            "breakdown": response.text
        })

    except Exception:
        return jsonify({
            "status": "error",
            "message": "The AI service could not process the task."
        }), 500


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)
