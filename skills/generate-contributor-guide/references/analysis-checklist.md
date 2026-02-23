# Stack-Specific Analysis Checklists

Use these checklists to guide what to analyze per codebase layer.
Not all items apply to every project - adapt based on what exists.

## Ruby / Rails

### Models (`app/models/`)
- File structure ordering (includes, constants, associations, validations, callbacks, scopes, methods)
- Concern usage and organization (`app/models/concerns/` vs `app/modules/`)
- Association conventions (grouping, inline scopes, explicit foreign keys)
- Validation patterns (conditional validations, custom validators)
- State machine gem and patterns (transitions, callbacks, guards)
- Soft delete pattern (`.alive` scope, `Deletable` concern, etc.)
- Callback patterns (lifecycle grouping, conditional callbacks)
- External/public ID strategy (obfuscation, Nano IDs, UUIDs)
- Enum patterns
- JSON data accessors or store_accessor usage
- Flag/boolean management (FlagShihTzu, bitfields, or plain booleans)
- Paper trail / auditing

### Controllers (`app/controllers/`)
- Base controller hierarchy and what each provides
- Authorization framework (Pundit, CanCanCan, custom) and how it's called
- Authentication patterns (before_action, current_user context)
- Rendering patterns (Inertia, Turbo, JSON API, traditional views)
- Strong params patterns (inline vs delegated to policy)
- Error handling (rescue_from, format-aware responses)
- Pagination approach (Pagy, Kaminari, custom)
- Concerns in `app/controllers/concerns/`

### Services (`app/services/`)
- Initialization and execution patterns (initialize + perform/call/process)
- Return value conventions (self, hash with success key, result object)
- Error handling approach (exceptions vs error hashes vs model errors)
- Transaction usage
- Race condition handling patterns

### Background Jobs (`app/sidekiq/` or `app/jobs/`)
- Job framework (Sidekiq, GoodJob, Delayed Job)
- Naming conventions (Job vs Worker suffix)
- Queue selection conventions
- Locking/deduplication strategy
- Argument serialization (IDs only vs complex objects)
- Retry and error handling patterns
- Batch processing / fan-out patterns

### Presenters / Serializers
- Pattern used (Presenter, Serializer, JBuilder, Blueprinter, etc.)
- How data is transformed for frontend consumption
- Caching strategies

### Policies (`app/policies/`)
- Authorization pattern (role-based, resource-based, multi-tenant)
- Method naming conventions
- How context objects are structured

### Tests (`spec/` or `test/`)
- Framework (RSpec, Minitest)
- Test description conventions (no "should", imperative mood, etc.)
- Data setup (FactoryBot, fixtures, let blocks, before hooks)
- Factory patterns (traits, nested factories, transient attributes)
- Shared examples / shared contexts
- VCR / WebMock patterns for external API testing
- System test patterns (Capybara matchers, custom helpers)
- Assertion style and custom matchers
- What emails/domains are used in tests

## JavaScript / TypeScript (Node.js)

### Project Structure
- Module system (ESM vs CJS)
- TypeScript strictness level (strict, exactOptionalPropertyTypes, etc.)
- Path aliases (@/, $app/, etc.)
- Monorepo structure if applicable (packages, workspaces)

### API Layer (Express, Fastify, Hono, etc.)
- Route organization (file-per-resource, router pattern)
- Middleware patterns (auth, validation, error handling)
- Request validation (Zod, Joi, class-validator)
- Response format conventions
- Error handling middleware

### Data Layer
- ORM/query builder (Prisma, Drizzle, TypeORM, Knex)
- Migration patterns
- Model/entity definition style
- Relationship handling

### Services / Use Cases
- Class-based vs function-based
- Dependency injection patterns
- Return type conventions (Result type, throwing, etc.)

### Tests
- Framework (Jest, Vitest, Mocha)
- Test organization (colocated vs separate test directory)
- Mocking patterns
- Fixture/factory approach
- Integration vs unit test conventions

## React / Frontend (standalone or within full-stack)

### Components
- Component file naming (PascalCase, kebab-case, index.tsx barrel exports)
- Functional components (arrow vs function declaration)
- Props typing patterns (inline vs separate type/interface)
- Component composition patterns (render props, compound, HOC)
- Directory organization (feature-based, type-based)

### State Management
- Global state (Redux, Zustand, Context, Jotai, none)
- Server state (React Query, SWR, Inertia)
- Form state (useForm, React Hook Form, Formik)
- Local component state patterns

### Styling
- Methodology (Tailwind, CSS Modules, styled-components, SCSS)
- Class name utilities (classNames, clsx, cn, tailwind-merge)
- Dynamic class handling (lookup maps vs template literals)
- Design token / theme approach

### Data Fetching
- Fetch abstraction (custom request utility, axios, ky)
- API type generation or manual typing
- Error handling patterns
- Loading/error state conventions

### Type Patterns
- Where types live (colocated, central types/ directory, data/ files)
- Casting approach (ts-safe-cast, type assertions, runtime validation)
- Strictness conventions (no any, unknown handling)

## Python

### Project Structure
- Package manager (uv, poetry, pip)
- Project config (pyproject.toml sections)
- Module organization (flat, src layout, namespace packages)

### Web Framework (Django, FastAPI, Flask)
- View/endpoint patterns
- Serialization (DRF serializers, Pydantic models)
- Authentication/authorization approach
- Middleware patterns

### Models / Data Layer
- ORM patterns (Django ORM, SQLAlchemy)
- Migration tooling
- Model method conventions
- Manager/queryset patterns (Django) or repository pattern

### Services
- Class-based vs function-based
- Return type conventions (dataclass, TypedDict, tuple)
- Error handling (exceptions vs Result type)

### Tests
- Framework (pytest, unittest)
- Fixture patterns (pytest fixtures, factory_boy)
- Assertion style (assert vs self.assertEqual)
- Mocking conventions (monkeypatch, mock.patch)

## Go

### Project Structure
- Directory layout (standard Go project layout, cmd/, internal/, pkg/)
- Module naming conventions

### Patterns
- Interface design and where interfaces are defined
- Error handling (sentinel errors, custom error types, wrapping)
- Context propagation
- Dependency injection approach
- Goroutine/channel patterns

### Tests
- Table-driven tests pattern
- Test helper conventions
- Mocking approach (interfaces, testify, gomock)
- Integration test organization

## Rust

### Project Structure
- Workspace organization
- Module hierarchy (mod.rs vs file-per-module)
- Feature flags

### Patterns
- Error handling (thiserror, anyhow, custom Error enum)
- Trait design conventions
- Builder pattern usage
- Async runtime (tokio, async-std)

### Tests
- Module tests (#[cfg(test)])
- Integration test organization
- Property-based testing
- Fixture patterns

## Java / Spring Boot

### Project Structure
- Build tool (Maven vs Gradle) and directory conventions (src/main/java, src/test/java)
- Package naming (com.company.project.module pattern)
- Multi-module project layout (parent POM, module dependencies)
- Java version and language feature usage (records, sealed classes, pattern matching)
- Lombok usage and which annotations are preferred (@Data, @Builder, @Value, etc.)

### Spring Patterns
- Component stereotypes (@Service, @Repository, @Component, @Controller) and when each is used
- Dependency injection style (constructor injection vs field injection)
- Configuration approach (@Configuration classes, application.yml vs application.properties, profiles)
- Bean lifecycle and scope conventions
- Exception handling (@ControllerAdvice, @ExceptionHandler, custom exception hierarchy)
- AOP usage (logging, security, transaction aspects)

### Controllers / REST API
- Controller layer patterns (@RestController vs @Controller)
- Request/response DTO conventions (records, inner classes, separate packages)
- Validation approach (Jakarta Bean Validation annotations, custom validators)
- Response wrapping (ResponseEntity usage, custom response envelope)
- API versioning strategy (URL path, headers, none)
- Swagger/OpenAPI annotation conventions

### Data Layer
- ORM (Spring Data JPA, Hibernate, MyBatis, jOOQ)
- Entity conventions (base entity class, audit fields, soft deletes)
- Repository patterns (Spring Data interfaces, custom queries, @Query vs method naming)
- Transaction management (@Transactional placement - service vs repository)
- Migration tooling (Flyway, Liquibase) and naming conventions
- Database constraint philosophy (JPA constraints vs DB-level)

### Services
- Service layer organization (interface + impl vs concrete classes)
- Method naming conventions
- Return type patterns (Optional, custom Result type, throwing exceptions)
- Transaction boundaries
- Inter-service communication patterns

### Background Processing
- Framework (Spring @Scheduled, Quartz, Spring Batch)
- Async patterns (@Async, CompletableFuture)
- Message queue integration (Kafka, RabbitMQ, SQS) and listener conventions
- Retry patterns (Spring Retry, resilience4j)

### Tests
- Framework (JUnit 5, AssertJ, Mockito)
- Test class naming (*Test vs *Tests vs *IT for integration)
- Slice testing patterns (@WebMvcTest, @DataJpaTest, @SpringBootTest scope)
- Mocking conventions (@MockBean, @Mock, when/given style)
- Test data setup (builders, @Sql scripts, TestContainers)
- Integration test database strategy (H2, TestContainers, embedded)
- Test configuration and profiles

## C# / .NET

### Project Structure
- Solution organization (.sln, .csproj, project references)
- Namespace conventions (matching folder structure or independent)
- Layer separation (Clean Architecture, Vertical Slices, N-Tier)
- Target framework version and C# language features used (records, pattern matching, primary constructors)
- NuGet package management (central package management, Directory.Build.props)

### API Layer (ASP.NET Core)
- Controller style (traditional controllers vs minimal APIs)
- Routing conventions (attribute routing, convention-based)
- Model binding and validation (FluentValidation, DataAnnotations)
- Response patterns (IActionResult, ActionResult<T>, Results in minimal APIs)
- Middleware pipeline configuration order
- Exception handling (middleware, filters, ProblemDetails)
- API versioning approach

### Data Layer
- ORM (Entity Framework Core, Dapper, both)
- DbContext organization (single vs multiple contexts, configuration)
- Entity configuration (Fluent API vs Data Annotations, IEntityTypeConfiguration)
- Migration conventions (naming, when to squash)
- Repository pattern usage (generic repository, specification pattern, or direct DbContext)
- Unit of Work patterns
- Query patterns (IQueryable composition, projection, split queries)

### Services / Business Logic
- Dependency injection registration patterns (extension methods, modules)
- Service lifetime conventions (Scoped vs Transient vs Singleton)
- MediatR / CQRS patterns if used (command/query separation, handlers, pipeline behaviors)
- Result type patterns (FluentResults, custom Result<T>, OneOf)
- Validation placement (in handlers, in services, FluentValidation pipeline)

### Background Processing
- Framework (IHostedService, BackgroundService, Hangfire, Quartz.NET)
- Channel/queue patterns for in-process work
- Message bus integration (MassTransit, NServiceBus, raw Azure Service Bus/RabbitMQ)

### Tests
- Framework (xUnit, NUnit, MSTest)
- Assertion library (FluentAssertions, Shouldly, built-in)
- Mocking library (Moq, NSubstitute, FakeItEasy)
- Test class organization (one class per method, per behavior, per scenario)
- Test naming convention (MethodName_Condition_ExpectedResult, Should_X_When_Y, plain English)
- Integration test patterns (WebApplicationFactory, TestContainers, Respawn for DB cleanup)
- Test fixture patterns (IClassFixture, collection fixtures)
- AutoFixture / Bogus for test data generation

## PHP / Laravel

### Project Structure
- Laravel version and directory conventions
- Custom directory organization beyond defaults (app/Actions, app/Services, app/DTOs, etc.)
- Namespace conventions
- Composer autoload configuration
- Module/package organization for larger apps (Laravel Modules, domain folders)

### Models (Eloquent)
- Model file organization and base model usage
- Attribute casting ($casts array conventions)
- Accessor/mutator patterns (new-style Attribute class vs get/set methods)
- Relationship definitions (ordering, return types, naming)
- Scope conventions (local scopes, global scopes)
- Soft delete usage (SoftDeletes trait)
- Factory patterns (definition style, states, sequences)
- Observer vs model event hooks
- Mass assignment protection ($fillable vs $guarded)

### Controllers
- Controller type (resource controllers, invokable, API resource controllers)
- Form Request usage and validation organization
- Authorization approach (Gates, Policies, middleware)
- Response patterns (Inertia, Blade, API Resources/JsonResource)
- Route model binding conventions
- Controller size philosophy (thin controllers, actions pattern)

### Services / Actions
- Service class conventions (single method, __invoke, multiple methods)
- Action pattern if used (single-responsibility classes)
- DTO patterns (spatie/data-transfer-object, custom, Laravel Data)
- Return value conventions
- Pipeline pattern usage

### Queued Jobs
- Job naming conventions
- Queue connection and queue name selection
- Retry and failure handling (tries, backoff, failed method)
- Job chaining and batching patterns
- Unique job patterns (ShouldBeUnique)
- Event/listener patterns vs direct job dispatch

### Frontend Integration
- Frontend approach (Inertia + Vue/React, Livewire, Blade + Alpine, API-only)
- Asset bundling (Vite, Mix)
- Component organization if using Inertia/Livewire

### Tests
- Framework (PHPUnit, Pest)
- Test organization (Feature vs Unit directories)
- Database strategy (RefreshDatabase, DatabaseTransactions, LazilyRefreshDatabase)
- Factory usage patterns (states, afterCreating hooks)
- HTTP test patterns (actingAs, assertJson, assertInertia)
- Mock/fake conventions (Bus::fake, Queue::fake, Notification::fake)
- Test naming convention (test_ prefix vs @test annotation, it() in Pest)
- Custom assertion patterns

## Kotlin

### Project Structure
- Build tool (Gradle Kotlin DSL vs Groovy DSL, Maven)
- Source layout (src/main/kotlin, package conventions)
- Kotlin version and language features used (coroutines, value classes, context receivers)
- Multiplatform setup if applicable (common, jvm, js, native source sets)
- Module organization

### Android (if applicable)
- Architecture pattern (MVVM, MVI, Clean Architecture)
- Jetpack Compose vs XML layouts (or migration state)
- ViewModel conventions (StateFlow vs LiveData, UI state modeling)
- Navigation approach (Navigation Component, type-safe routes)
- Dependency injection (Hilt/Dagger, Koin, manual)
- Repository pattern implementation
- Coroutine scope and dispatcher conventions
- Resource management (strings, dimensions, themes)

### Server-Side (Ktor, Spring Boot with Kotlin)
- Framework choice and routing style
- Serialization (kotlinx.serialization, Jackson Kotlin module, Moshi)
- Coroutine usage in request handling
- Extension function conventions
- DSL usage patterns

### Data Layer
- Database access (Exposed, Room, Spring Data, SQLDelight)
- Entity/model class conventions (data class, value class usage)
- Null safety patterns (how nullable vs non-nullable is decided)
- Sealed class/interface usage for domain modeling

### Patterns and Idioms
- Extension function conventions (where they live, naming)
- Sealed class hierarchies for state/result/error modeling
- Coroutine patterns (structured concurrency, supervision, exception handling)
- Scope function usage conventions (let, run, apply, also, with)
- Data class vs class decisions
- Companion object patterns
- DSL builder patterns if used

### Tests
- Framework (JUnit 5, Kotest)
- Assertion library (Kotest matchers, AssertJ, Truth, kotlin.test)
- Coroutine testing (runTest, TestDispatcher, Turbine for Flow)
- Mocking (MockK vs Mockito-Kotlin)
- Test naming conventions (backtick names vs camelCase)
- Android-specific: Robolectric, Compose testing, instrumented vs local tests
- Test data patterns (object mothers, builders, fixture functions)

## Universal Checklist (All Stacks)

### Git Conventions
- Commit message format (conventional commits, custom, freeform)
- Branch naming conventions
- PR size expectations
- Force push policy
- Squash vs merge vs rebase

### Documentation
- PR template requirements (self-review, screenshots, test output)
- AI disclosure requirements
- Code comment policy (expected, discouraged, or none)
- Changelog conventions

### Architecture
- Where business logic lives (models, services, use cases)
- Where validation happens (model, controller/handler, both)
- Background processing conventions
- Feature flag system
- External ID strategy
- Database constraint philosophy (strict vs loose)

### CI/CD
- Required checks before merge
- Linter configuration and strictness
- Test coverage requirements
