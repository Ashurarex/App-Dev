const prompt = require("prompt-sync")();  
let data = [];

function menu() {
    let choice;
    do {
        console.log("1. Create");
        console.log("2. Read");
        console.log("3. Update");
        console.log("4. Delete");
        console.log("5. Exit");

        choice = prompt("Enter your choice: ");

        switch (choice) {
            case "1": // CREATE
                let item = prompt("Enter item to add: ");
                data.push(item);
                console.log("Item added successfully!");
                break;

            case "2": // READ
                if (data.length === 0) {
                    console.log("No items in the array!");
                } else {
                    console.log("Items:", data.join(", "));
                }
                break;

            case "3": // UPDATE
                let to_update = parseInt(prompt("Enter index to update (starting from 0): "));
                if (to_update >= 0 && to_update < data.length) {
                    let newValue = prompt("Enter new value: ");
                    data[to_update] = newValue;
                    console.log("Item updated successfully!");
                } else {
                    console.log("Invalid index!");
                }
                break;

            case "4": // DELETE
                let to_delete = parseInt(prompt("Enter index to delete (starting from 0): "));
                if (to_delete >= 0 && to_delete < data.length) {
                    data.splice(to_delete, 1);
                    console.log("Item deleted successfully!");
                } else {
                    console.log("Invalid index!");
                }
                break;

            case "5": // EXIT
                console.log("Exiting program...");
                break;

            default:
                console.log("Invalid choice! Please enter between 1–5.");
        }
    } while (choice !== "5");
}
