<img width="740" height="1538" alt="image" src="https://github.com/user-attachments/assets/0e0754a4-58de-4df4-9e23-e411048472bf" />
<img width="758" height="1574" alt="image" src="https://github.com/user-attachments/assets/dc7a1985-d75d-4ac0-8d77-edf203b6f428" />

#  BookCart

Book Cart app in SwiftUI.

#  BookCart

This article shows how to create a simple **BookCart** app in SwiftUI.
The main features are:
- Detailed with book image, author and name of the book.
- Core logic, viewModel, and views are structured for reusability.
- Fetches book details via an HTTP request to public API.
- Presents the Book image along with detailed descriptions.
- Extracts metadata including image URL, title, author, and name.
- User Options – Allows users to:
     - View list of books images.
     - Select an book image from a specific grid.
- Supports Dynamic Type, Dark Mode, and an adaptive SwiftUI layout.
- Ensures previously loaded images and data can be viewed offline.

# Test Scenarios      

Success Responses: Include images of book, Name of the author and book name.
- The app shows you the latest books.
- It saves them in the background so they’re available even if you go offline later.

Failure Response 
- Always check the status code (400, 403, 429, 500).
- Display user-friendly messages based on the error type:
     - "Invalid request. Please try again."
     - "Access denied. Please check your credentials."
     - "Too many requests. Please wait and try again."
     - "Something went wrong. Please try later."

# Unit Testing

- Covers BookService
- View Model is also tested. 
