# Flutter — Fetch Public REST API (Posts) Example

This project is a minimal Flutter app that fetches posts from the public JSONPlaceholder API and displays them in a scrollable list with loading, empty and error states.

## What you get
- Clear separation: repository, viewmodel, UI, and models
- Uses `dio` HTTP client and `provider` for state management
- `loadPosts()` shows a loading spinner, an empty state when no results, and an error view on failures
- Pull-to-refresh and a Reload button

## How to run
1. Ensure you have Flutter installed (stable channel).
2. Extract the project and run `flutter pub get`.
3. Run with `flutter run` on an emulator or device.

## Files of interest
- `lib/src/post_model.dart` — Post model
- `lib/src/posts_repository.dart` — Fetches from `https://jsonplaceholder.typicode.com/posts`
- `lib/src/posts_viewmodel.dart` — ViewModel with states (busy, idle, empty, error)
- `lib/src/posts_list_page.dart` — UI: list, loading, error, empty states

## Notes
- This project uses the public JSONPlaceholder API for demo purposes.
- You can swap the repository to call a different API endpoint as needed.
