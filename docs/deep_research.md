Next Gen Job Portal Flutter App – AI-Executable Implementation Guide

This guide provides a step-by-step, CLI-first roadmap to implement the Next Gen Job Portal Flutter app in a modular monorepo using GetX, Firebase, Mason, and Melos. It breaks down work by module, with specific commands, package choices, folder conventions, testing requirements (90%+ coverage), time estimates, CI/CD actions, and logging duties. Follow each step precisely to ensure a consistent, high-quality codebase.

🏗 Architecture & Initial Setup
	•	Monorepo with Melos:
	1.	Install Melos:

flutter pub global activate melos


	2.	Initialize Melos workspace:

melos init

	•	Melos.yaml: Create melos.yaml at repo root with packages: including each module (see Git Strategy).

	3.	Bootstrap packages:

melos bootstrap

	•	This links local packages and installs dependencies.

	•	Flutter Project Initialization (if not existing):

flutter create next_gen_job_portal
cd next_gen_job_portal

	•	Update pubspec.yaml to support workspaces if needed.

	•	GetX CLI & Mason Setup:

dart pub global activate getx_cli
dart pub global activate mason_cli

	•	Verify: getx --version, mason --version.

	•	Firebase (FlutterFire CLI):

flutter pub global activate flutterfire_cli
flutterfire login
flutterfire configure

	•	Targets Web/Android/iOS if needed.
	•	The above generates lib/firebase_options.dart and configures Firebase core.

	•	Project Structure (Atomic Design):
	•	Use an atomic design folder layout in each UI module:

lib/
  core/             # services, utils, constants
  modules/          # feature modules (each a Melos package)
  shared/           # shared widgets, atoms/molecules
  app_pages.dart    # routing 
  app_routes.dart


	•	Example: lib/modules/auth/view/login_page.dart, lib/modules/auth/controller/auth_controller.dart.

	•	Commit Conventions & Logging:
	•	In activity_log.md, record each major task (date, duration, summary).
	•	README: update with setup steps and module summary as progress.

🌲 Git & Branching Strategy
	•	Repository Initialization:

git init
git remote add origin <repo-url>


	•	Branching:
	•	Use feature/<module_name> for each module (e.g., feature/auth).
	•	Use hotfix/<issue> for urgent fixes, release/x.y.z for releases.
	•	Commit Messages:
	•	Prefix: [feat/auth], [fix/job], [chore], etc.
	•	Follow Conventional Commits: feat:, fix:, docs:, test:, refactor:, etc.
	•	Pull Requests:
	•	One feature per PR. Include description, testing steps.
	•	Require at least 2 code reviews before merge.
	•	Use GitHub Checks for CI (see CI/CD section).
	•	Logging:
	•	After finishing tasks on a branch, update docs/activity_log.md with time spent and summary.
	•	On merge, ensure README.md is updated to reflect new functionality.

🎨 Design & UI Guidelines
	•	Atomic Design: Organize reusable widgets as Atoms, Molecules, Organisms:
	•	E.g., lib/shared/atoms/button_atom.dart, lib/shared/molecules/job_card.dart.
	•	CRED-Level UI (High-Fidelity):
	•	Follow style guide with consistent padding, typography, and colors.
	•	Use custom themes (light_theme.dart, dark_theme.dart) under lib/app/themes.
	•	Accessibility Compliance:
	•	All interactive widgets must have Semantics labels and sufficient color contrast.
	•	Support screen readers (e.g. Semantics(label: 'Login button')).
	•	Respect text scaling (use MediaQuery.textScaleFactor).
	•	Animations:
	•	Use Flutter’s animation libraries (e.g., flutter_animate, implicit animations) for transitions and loading indicators.
	•	Example: shimmer effect for loading job list, Hero animations for navigation.
	•	State Management:
	•	Use GetX (Controllers + Bindings) for reactive state and dependency injection.
	•	TDD-First:
	•	Write failing tests before implementing features.
	•	Ensure 90%+ test coverage per feature (unit, widget, integration).

🚀 CI/CD & Automation
	•	CI Pipeline (GitHub Actions):
	•	On PR:
	•	Run flutter format --set-exit-if-changed . to enforce style.
	•	Run flutter analyze (static analysis).
	•	Run melos test or flutter test --coverage.
	•	Generate coverage report; require >=90% coverage.
	•	Badge: coverage / build status.
	•	On Merge to Main:
	•	Deploy automatically (e.g., to Firebase Hosting or App Distribution).
	•	Run smoke tests (optional).
	•	Tag release (v1.0.0, etc) using git tag and push.
	•	Melos Scripts:
	•	In melos.yaml, define scripts:

scripts:
  format: flutter format .
  analyze: flutter analyze
  test: flutter test --coverage


	•	Use melos run format, melos run analyze, melos run test in CI steps.

	•	Automatic Checks:
	•	Enforce commit lint (Conventional Commits) via CI bot if available.
	•	Check for activity_log.md updates.
	•	Ensure README.md mentions new modules.

🔍 Testing Strategy
	•	Unit Tests:
	•	Target business logic in controllers and services.
	•	Mock external dependencies (e.g., Firebase Auth, Firestore) using packages like mockito or mocktail.
	•	Example: test AuthController.login() handles success and failure.
	•	Widget Tests:
	•	Test UI components and pages in isolation.
	•	Example: verify login form validation, button states, rendering of a JobCard.
	•	Use pumpWidget() with GetMaterialApp wrapper to test navigation and bindings.
	•	Integration Tests:
	•	End-to-end flows using flutter_driver or integration_test.
	•	Example: full sign-up/login flow, resume upload flow with emulator.
	•	Coverage:
	•	Aim 90%+ coverage per module. Use flutter test --coverage and report via Codecov or Coveralls.
	•	Fail the PR if coverage drops below threshold.

🔢 Module Breakdown & Implementation Plan

The following table summarizes each module with key CLI commands, tasks, estimated hours, and required tests. Detailed steps follow in each section.

Module	Key CLI Commands	Key Tasks	Est. Hours	Tests
Auth	getx create module:auth	Login/Signup UI, Firebase Auth integration	10h	Unit, Widget, Integration
Resume Upload	getx create module:resume	Upload to Firebase Storage, resume list view	10h	Unit, Widget, Integration
Job Feed	getx create module:job	Job listings, details, search/filtering	15h	Unit, Widget, Integration
Admin Panel	getx create module:admin	Admin dashboard, CRUD jobs, manage users	17h	Unit, Widget (Integration)
Notifications	getx create module:notification	Push notifications (FCM) and local list	4h	Unit, Widget
Profile	getx create module:profile	User profile view/edit, auth info	3h	Unit, Widget

1. Auth Module (feature/auth)
	•	Branch: feature/auth
	•	CLI Scaffolding (0.5h):

getx create module:auth

	•	Creates lib/modules/auth with GetX controller/view structure.

	•	Dependencies (0.5h):
Add to modules/auth/pubspec.yaml (or global):

dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5
  firebase_core: ^2.0.0
  firebase_auth: ^4.0.0
  google_sign_in: ^6.0.0

Run flutter pub get.

	•	Firebase Auth Setup (1h):
	•	Ensure flutterfire configure was run at root.
	•	In main.dart, initialize Firebase:

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


	•	Configure authentication providers (enable Email/Password, Google in console).

	•	UI Implementation (3h):
	•	Create LoginPage (lib/modules/auth/view/login_page.dart): email & password fields, “Sign In” button.
	•	Create SignupPage (signup_page.dart) with Name, Email, Password.
	•	Use atoms for common widgets: e.g. shared/atoms/text_field_atom.dart, button_atom.dart.
	•	Implement navigation links (e.g., “Don’t have an account? Sign up” using GetX routing).
	•	Add subtle animation (e.g., fade-in on page load).
	•	Accessibility: wrap form fields with Semantics(label: 'Email input').
	•	Controller Logic (2h):
	•	AuthController (lib/modules/auth/controller/auth_controller.dart): methods login(), register(), logout().
	•	Use GetX Rx variables for form state (isLoading, errorMessage).
	•	Example using FirebaseAuth:

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> user = Rx<User?>(null);
  login(email, password) async { ... }
}


	•	Update UI on success/failure.

	•	Routing (0.5h):
	•	In app_pages.dart, add routes for /login and /signup, binding AuthController.
	•	Testing (4h):
	•	Unit Tests: Mock FirebaseAuth using mockito/mocktail. Test AuthController.login() success and error flows. Achieve ~95% coverage on AuthController.
	•	Widget Tests:
	•	Test LoginPage renders fields and button.
	•	Simulate input and verify controller calls.
	•	Use pumpWidget(GetMaterialApp(home: LoginPage())).
	•	Integration Test: Automate a full login scenario with the emulator (optional Firebase emulator).
	•	Git & CI (0.5h):
	•	Commit with [feat/auth]. Push feature/auth.
	•	PR triggers CI: ensure formatting, analysis, and tests pass.
	•	Documentation (0.5h):
	•	Log tasks/hours in docs/activity_log.md.
	•	Update README: describe Auth module features and setup.

Total Auth Module: ~10 hours

2. Resume Upload Module (feature/resume_upload)
	•	Branch: feature/resume_upload
	•	CLI Scaffolding (0.5h):

getx create module:resume

	•	Creates lib/modules/resume scaffold.

	•	Dependencies (0.5h):

dependencies:
  file_picker: ^5.2.2
  firebase_storage: ^11.0.0
  firebase_core: ^2.0.0
  get: ^4.6.5

flutter pub get.

	•	UI: Upload Page (2h):
	•	ResumeUploadPage (lib/modules/resume/view/resume_upload_page.dart):
	•	Button “Select Resume” (File Picker).
	•	Show file name preview and “Upload” button.
	•	Use IconAtom, ButtonAtom, and progress indicator (e.g., CircularProgressIndicator).
	•	Ensure file type restriction (e.g., PDF) with FilePicker.platform.pickFiles().
	•	Animation: Show upload progress with animated progress bar.
	•	Accessibility: add Semantics(label: 'Upload resume button').
	•	Controller Logic (2h):
	•	ResumeController (lib/modules/resume/controller/resume_controller.dart):

Future<void> uploadResume(File file) async {
  final ref = FirebaseStorage.instance.ref().child('resumes/${file.name}');
  await ref.putFile(file);
  final url = await ref.getDownloadURL();
  // Optionally save metadata to Firestore:
  await FirebaseFirestore.instance.collection('resumes').add({
    'url': url, 'name': file.name, 'uploadedAt': DateTime.now(),
  });
}


	•	Handle errors, update isUploading Rx var, show snackbars on result.

	•	UI: Resume List (1h):
	•	ResumeListPage (lib/modules/resume/view/resume_list_page.dart):
	•	Fetch and display uploaded resumes (name, date).
	•	Use ListView.builder with ListTile, include “Download” icon.
	•	Use GetX reactive binding to update when new resume uploaded.
	•	Testing (3h):
	•	Unit: Mock FirebaseStorage and FirebaseFirestore. Test uploadResume() handles success and exceptions.
	•	Widget:
	•	Test ResumeUploadPage renders buttons and reacts to taps.
	•	Use pumpWidget with GetMaterialApp.
	•	Integration: (Optional) simulate picking a file and uploading via emulator.
	•	Git & CI (0.5h):
	•	Branch/commit: [feat/resume]. Run CI checks.
	•	Documentation (0.5h):
	•	Log progress in activity_log.md. Update README with resume feature.

Total Resume Module: ~10 hours

3. Job Feed Module (feature/job_feed)
	•	Branch: feature/job_feed
	•	CLI Scaffolding (0.5h):

getx create module:job

	•	Creates lib/modules/job.

	•	Dependencies (0.5h):

dependencies:
  cloud_firestore: ^4.4.5
  get: ^4.6.5

flutter pub get.

	•	Data Model (1h):
	•	Create JobModel in lib/modules/job/data/models/job_model.dart:

class JobModel {
  final String id, title, company, location, description;
  final int salary;
  final DateTime postedDate;
  JobModel({ ... });
  factory JobModel.fromJson(Map<String,dynamic> json) => ...;
}


	•	Firestore Setup (0.5h):
	•	Create a jobs collection in Firestore with sample documents.
	•	UI: Job List (3h):
	•	JobListPage (lib/modules/job/view/job_list_page.dart):
	•	AppBar with title and search icon.
	•	Use StreamBuilder or FutureBuilder to list jobs:

final jobs = FirebaseFirestore.instance.collection('jobs').snapshots();


	•	ListView.builder with custom JobCard molecule: show title, company, brief.
	•	Shimmer effect while loading (use shimmer package).

	•	Infinite scroll/pagination if needed.
	•	Accessibility: ensure tappable area of each card is large, use Semantics for job info.

	•	UI: Job Detail (2h):
	•	JobDetailPage (lib/modules/job/view/job_detail_page.dart):
	•	Display full job details (description, responsibilities).
	•	“Apply” button and bookmark icon.
	•	Data passed via GetX route arguments or query Firestore by jobId.
	•	Animation: hero transition for job title or fade-in detail.
	•	Search & Filter (2h):
	•	Add SearchBarAtom in the AppBar. On text change, filter Firestore query (where('title', arrayContains: query)).
	•	Add Filter button: open a bottom sheet with options (e.g., location, salary range).
	•	Apply Action (1h):
	•	In JobController, implement applyToJob(jobId):
	•	Add entry under applications collection with userId and jobId.
	•	Show confirmation dialog.
	•	Testing (4h):
	•	Unit: Test JobController.fetchJobs() and filter logic. Mock Firestore snapshots.
	•	Widget:
	•	Test JobListPage displays a list when given sample data.
	•	Test search bar filtering effect on UI.
	•	Integration: Simulate user searching and viewing details.
	•	Git & CI (0.5h):
	•	Branch/commit: [feat/job]. Ensure all checks pass.
	•	Documentation (0.5h):
	•	Log work in activity_log.md. Update README with job feed usage.

Total Job Feed Module: ~15 hours

4. Admin Panel Module (feature/admin_panel)
	•	Branch: feature/admin_panel
	•	CLI Scaffolding (1h):

getx create module:admin

	•	Creates lib/modules/admin.

	•	Dependencies (1h):

dependencies:
  get: ^4.6.5
  cloud_firestore: ^4.4.5
  charts_flutter: ^0.12.0

flutter pub get.

	•	Admin Auth (1h):
	•	Extend Auth flow: add an isAdmin flag in Firestore users collection.
	•	Protect admin routes: in AdminController, check currentUser.isAdmin.
	•	If not admin, redirect to user home.
	•	Dashboard UI (3h):
	•	AdminDashboardPage: show key metrics.
	•	Use charts_flutter or fl_chart for graphs (e.g., bar chart of daily signups, pie chart of active vs inactive jobs).
	•	Display summary cards: total users, total jobs, pending applications.
	•	Organize widgets as Organisms (stats_card, chart_widget).
	•	Job Management (3h):
	•	AdminJobsPage: list all jobs with Edit/Delete options.
	•	“+ Add Job” button opens a form (reuse Job model) to create or edit a job.
	•	On delete, show confirmation.
	•	Use Firestore read/write for CRUD.
	•	User Management (2h):
	•	AdminUsersPage: list all registered users.
	•	Show name, email, role, active status.
	•	Toggle admin role or deactivate account.
	•	Testing (5h):
	•	Unit: Test admin controllers (e.g. createJob(), deleteUser() with mocks).
	•	Widget:
	•	Test that Admin pages render correct charts and lists.
	•	Simulate button taps (e.g. deleting a job).
	•	Git & CI (0.5h):
	•	Branch/commit: [feat/admin]. Run all CI steps.
	•	Documentation (0.5h):
	•	Record tasks in activity_log.md. Update README (mention admin credentials/setup).

Total Admin Module: ~17 hours

5. Notifications Module (feature/notifications)
	•	Branch: feature/notifications
	•	CLI Scaffolding (0.2h):

getx create module:notification


	•	Dependencies (0.5h):

dependencies:
  firebase_messaging: ^14.0.0
  flutter_local_notifications: ^13.0.0

flutter pub get.

	•	Firebase Messaging Setup (1h):
	•	Configure FCM in Firebase console (Android/iOS settings).
	•	In main.dart, set up message handler:

FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


	•	Local Notifications (1h):
	•	Initialize FlutterLocalNotificationsPlugin and show notifications on message receipt when app is foreground.
	•	UI: Notification List (1h):
	•	NotificationsPage (lib/modules/notification/view/notification_page.dart):
	•	Display list of received notifications (title, body).
	•	Persist notifications in local DB or use a notifications collection in Firestore.
	•	Testing (1h):
	•	Unit: Test notification logic in controller (onMessageReceived).
	•	Widget: Ensure NotificationsPage lists a sample notification.
	•	Git & CI (0.2h):
	•	Branch/commit: [feat/notification].
	•	Documentation (0.1h):
	•	Log and README update.

Total Notifications Module: ~4 hours

6. Profile Module (feature/profile)
	•	Branch: feature/profile
	•	CLI Scaffolding (0.2h):

getx create module:profile


	•	Dependencies (0.2h):

dependencies:
  shared_preferences: ^2.0.15
  get: ^4.6.5

flutter pub get.

	•	UI: Profile Page (1h):
	•	ProfilePage (lib/modules/profile/view/profile_page.dart):
	•	Show user info (name, email, profile picture). “Edit” button.
	•	On edit: allow changing display name, uploading new profile image (use image_picker).
	•	Controller Logic (1h):
	•	ProfileController: fetch current user details from FirebaseAuth or Firestore.
	•	Save updates back to Firestore/user object. Use SharedPreferences to cache some data (e.g., theme choice).
	•	Testing (1h):
	•	Unit: Test ProfileController fetch/update functions with mocks.
	•	Widget: ProfilePage shows correct initial data and responds to edit.
	•	Git & CI (0.1h):
	•	Branch/commit: [feat/profile].
	•	Documentation (0.1h):
	•	Log and README.

Total Profile Module: ~3 hours

🧪 Tests & Coverage (Summary)

Module	Unit Tests (Controllers)	Widget Tests (UI)	Integration Tests (Flows)	Coverage Target
Auth	AuthController (login/signup)	LoginPage, SignupPage	Login flow	≥ 90%
Resume	ResumeController (upload logic)	ResumeUploadPage, ResumeListPage	Upload flow	≥ 90%
Job Feed	JobController (fetch/filter)	JobListPage, JobDetailPage	Search & view detail	≥ 90%
Admin	AdminController (create/delete)	AdminDashboard, AdminJobsPage	Admin CRUD actions	≥ 90%
Notifications	NotificationController	NotificationsPage	FCM receive flow	≥ 90%
Profile	ProfileController	ProfilePage	Profile edit flow	≥ 90%

	•	Use flutter test for unit/widget tests.
	•	Use flutter test integration_test/app_test.dart for integration tests.
	•	Collect coverage: flutter test --coverage.

📂 Folder Structure Conventions
	•	Modules as Packages (monorepo):

/packages
  /auth
    pubspec.yaml
    lib/
      controller/
      view/
      data/
  /resume
  /job
  /admin
  /notification
  /profile
/lib (app entry point)
/shared (common widgets, atoms/molecules)


	•	Naming: Keep file names lowercase with underscores.
	•	Controllers/Views: e.g. lib/modules/auth/controller/auth_controller.dart, lib/modules/auth/view/login_page.dart.
	•	Tests: Mirror structure under test/: e.g. test/modules/auth/auth_controller_test.dart.

🏁 Final Steps & CI Integration
	•	Merge & Release: After merging each feature, tag versions (using semantic versioning).
	•	CI Checks on PR: ensure passes all scripts (melos run format, analyze, test).
	•	Deployment: On main branch updates, trigger automated builds (e.g., Firebase deploy).
	•	Continuous Logging: Maintain docs/activity_log.md and update README.md with new module info after each merge.

By following this guide, the code agent will systematically scaffold, implement, test, and document each feature of the Next Gen Job Portal app, ensuring a modular, well-tested, and maintainable Flutter codebase. Each step includes the exact CLI commands, package selections, branch/commit rules, and estimated effort to keep development on schedule and high-quality.