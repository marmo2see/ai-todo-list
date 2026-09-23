const taskInput = document.getElementById("taskInput");
const addButton = document.getElementById("addButton");
const aiButton = document.getElementById("aiButton");
const taskList = document.getElementById("taskList");
const aiResponse = document.getElementById("aiResponse");
const API_BASE_URL =
    window.location.hostname === "127.0.0.1" ||
    window.location.hostname === "localhost"
        ? "http://127.0.0.1:5000"
        : "";

// Add task when button is clicked
addButton.addEventListener("click", addTask);

// Add task when Enter is pressed
taskInput.addEventListener("keydown", (event) => {
    if (event.key === "Enter") {
        addTask();
    }
});

// Function for adding a task
function addTask() {
    const task = taskInput.value.trim();

    if (!task) {
        return;
    }

    const li = document.createElement("li");

    const taskText = document.createElement("span");
    taskText.textContent = task;

    const deleteButton = document.createElement("button");
    deleteButton.textContent = "Delete";
    deleteButton.className = "deleteButton";

    deleteButton.addEventListener("click", () => {
        li.remove();
    });

    li.appendChild(taskText);
    li.appendChild(deleteButton);

    taskList.appendChild(li);

    // Clear the input field
    taskInput.value = "";
    taskInput.focus();
}


// AI Break Down button
aiButton.addEventListener("click", async () => {
    const task = taskInput.value.trim();

    if (!task) {
        aiResponse.textContent = "Enter a task first.";
        return;
    }

    aiResponse.textContent = "AI is thinking...";

    try {
        const response = await fetch(
            `${API_BASE_URL}/api/breakdown`,
             {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    task: task
                })
            }
        );

        const data = await response.json();

        if (!response.ok) {
            aiResponse.textContent =
                data.message || "An error occurred.";
            return;
        }

        aiResponse.textContent = data.breakdown;

    } catch (error) {
        aiResponse.textContent =
            "Could not connect to the backend.";

        console.error(error);
    }
});