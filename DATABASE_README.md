# Firebase Firestore Database Implementation

This document explains how Firebase Firestore is implemented in the SuEvent app.

## Database Structure

The database consists of two main collections:

### 1. clubs

Contains all clubs available in the application.

**Schema:**
- `id`: String (Firestore document ID)
- `name`: String - Club name
- `description`: String - Club description
- `events`: Array of Strings - Types of events the club holds
- `type`: String - Club type (career, sport, music)
- `image`: String - URL to club image
- `popularity`: Number - Popularity score (0-100)
- `createdBy`: String - UID of user who created the club
- `createdAt`: Timestamp - When the club was created

### 2. savedClubs

Tracks which clubs are saved by which users.

**Schema:**
- `id`: String (Firestore document ID)
- `userId`: String - UID of the user who saved the club
- `clubId`: String - ID of the saved club
- `savedAt`: Timestamp - When the club was saved

## Implementation Details

### Models

- `Club`: Represents a club entity with all necessary properties
- `SavedClub`: Represents the relation between a user and a saved club

### Services

- `FirestoreService`: Handles all CRUD operations for clubs and saved clubs
  - **Create**: Add new clubs to Firestore
  - **Read**: Retrieve clubs data
  - **Update**: Modify club information
  - **Delete**: Remove clubs from Firestore
  - **Save/Unsave**: Allow users to save and unsave clubs

### State Management

We use the Provider pattern for state management:

- `ClubProvider`: Manages club state, saved clubs, and communicates with Firestore
  - Loads clubs from Firestore
  - Tracks which clubs are saved by the current user
  - Provides filtered clubs based on search criteria and filters
  - Automatically updates UI when changes occur in the database

### Security Rules

Security rules are implemented to ensure:
- Users can read all clubs
- Users can only save/unsave clubs when authenticated
- Users can only see their own saved clubs
- Club creation requires authentication
- Only club creators can update or delete their clubs

## User-Specific Features

1. **Saved Clubs**: Each user has their own private list of saved clubs
2. **Club Management**: Users can save and unsave clubs
3. **Profile Integration**: The profile page shows the user's saved clubs
4. **Real-time Updates**: Changes in the database are immediately reflected in the UI

## Initialization

The database is initialized with sample club data if it's empty. This happens:
1. When the app starts for the first time
2. Through the `initializeApp()` function in `init_app.dart`

## Indexes

Custom Firestore indexes are defined to optimize:
- Queries for a user's saved clubs
- Filtering clubs by type
- Sorting clubs by popularity

## Future Enhancements

1. **User-Created Clubs**: Allow users to create their own clubs
2. **Club Attendance**: Track which users are attending club events
3. **Club Analytics**: Show statistics like number of members, events, etc.
4. **Event Scheduling**: Add event schedules for each club
5. **Notifications**: Notify users about updates to their saved clubs 