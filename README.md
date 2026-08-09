# petals_stack_tutorial
Tutorial for PETALS stack (Elixir, Phoenix, Tailwind, Ash, Live View, and Svelte)

Layer | Technology | Primary Role in PETALS
:--- | :--- | :---
**Runtime** | [Elixir](https://hexdocs.pm/elixir/introduction.html) | Handles concurrency, fault tolerance, and soft real-time execution via the Erlang BEAM VM.
**Web Framework** | [Phoenix](https://www.phoenixframework.org/) | Provides routing, WebSocket channels, HTTP handling, and high-throughput web performance.
**Styling** | [Tailwind CSS](https://tailwindcss.com/) | Offers rapid utility-first styling consistent across LiveView templates and Svelte components.
**Domain & Data** | [Ash Framework](https://ash-hq.org/) | Declaratively defines data resources, business logic, authorization policies, and auto-generated APIs.
**Server-Driven UI** | [Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/) | Manages real-time state and UI reactivity on the server over WebSockets, bypassing traditional APIs.
**Client-Driven UI** | [Svelte](https://svelte.dev/) | Handles complex, highly interactive, client-side UI components where server round-trips are impractical.

# Why use the PETALS stack?

## Why use Elixir?

Elixir runs on the Erlang VM which has many examples of scalability

- Ericson, the company that created Erlang, boasts only 5.2 minutes of downtime a year in their systems running Erlang.
- Whatsapp was able to maintain 2 million TCP connections on a single mid-tier server, using only 40% CPU, in 2012 using Erlang. [Source](https://blog.whatsapp.com/1-million-is-so-2011)
- A developer rewrote an AWS microservice application in Elixir. The resulting application was faster and cost less (from >$12K/month to ~$300/month) to run in the cloud. [Source](https://medium.com/coryodaniel/from-erverless-to-elixir-48752db4d7bc)
- Discord has many examples of using Elixir as thier primay language to scale to a large amount of users. [Source](https://discord.com/blog/using-rust-to-scale-elixir-for-11-million-concurrent-users)

Elixir was created by former Ruby/Rails devs that built it with improvements over Erlang

- Modern Ruby-like syntax
- Macro System to support metaprogramming and domain-specific languages
- Tooling (`mix` build tool and [hex package manager](https://hex.pm/))
- Many libraries and frameworks

## Reasons to Choose the PETALS Stack

### 1. Unified Backend Architecture via Ash Framework
Database migrations, schema definitions, context functions, GraphQL/REST endpoint controllers, authorization checks and more are centralized and declared.
* **Declarative Resources:** You define your data and business rules once as Ash Resources.
* **Auto-Derived Interfaces:** Ash automatically derives persistence rules, validation, background jobs, and GraphQL or JSON:API endpoints directly from your resource definitions.
* **Built-in Security & Policies:** Granular policy-based access control (RBAC/ABAC) is baked into the domain layer, ensuring security rules are enforced regardless of how data is accessed (LiveView, API, or background job).

### 2. High Velocity Without the "Two-Codebase" Overhead
Traditional full-stack apps require maintaining a separate REST/GraphQL API layer, complex client-side state management (like Redux), and data-fetching boilerplate. 
* **LiveView Handles 90% of UI:** Server-driven state means state management happens in one place—on the server. State changes trigger minimal HTML diffs pushed instantly over WebSockets.
* **No Manual Serialization:** You pass server data directly into UI components without writing client-side fetchers, TypeScript interfaces for API payloads, or cache-invalidation logic.

### 3. The "Best-of-Both-Worlds" Frontend (LiveView + Svelte)
Pure LiveView is good for standard forms, dashboards, tables, and CRUD operations. However it becomes complex during client-side UI interactions.
* **`live_svelte` Bridge:** Through libraries like `live_svelte`, Svelte components render seamlessly inside Phoenix LiveView templates.
* **Reactive Synergy:** LiveView owns the application state, database connection, and real-time synchronization, while Svelte handles complex local DOM manipulations. Svelte receives props directly from LiveView and sends events back up to the server with zero manual API wiring.
* **Minimal JavaScript Footprint:** Svelte compiles to small, efficient JavaScript without a virtual DOM, preserving the fast initial load times Elixir/Phoenix is known for.

### 4. Extreme Concurrency & Fault Tolerance
Because PETALS runs on Elixir and the Erlang BEAM you get world-class concurrency for free.
* **Massive Concurrency:** A single Phoenix server can maintain hundreds of thousands of simultaneous WebSocket connections with low memory usage.
* **Self-Healing Systems:** Built-in OTP supervisors isolate errors. If an individual WebSocket process or background task crashes, it restarts instantly without bringing down the server or impacting other users.
* **Built-in Pub/Sub:** Real-time features (collaborative editing, live notifications, dynamic feeds) require no external services like Redis or Socket.io.

### 5. Future-Proof Scalability for Small Teams
PETALS scales both technically and organizationally.
* **Monolith First, Microservice Ready:** Ash resources decouple domain logic from persistence. If a module needs to be extracted into a separate service later, Ash resources can switch storage backends or execution boundaries without rewriting business logic.
* **Low Maintenance Load:** Fewer infrastructure moving parts (no separate Node/React build pipeline, microservice API gateways, or external state caches) means a small team can manage a platform serving millions of users.

# Tutorial

## 1: Project Setup

Install Elixir
```bash
# install asdf (a tool for managing runtimes)
# Getting started: https://asdf-vm.com/guide/getting-started.html

# install erlang and elixir plugins
asdf plugin add erlang
asdf plugin add elixir

# install specific version for plugin
# use `asdf list all` or `asdf latest` to check for newer available versions
asdf install erlang 29.0.5
asdf install elixir 1.20.3-otp-29
```

Create a new Phoenix Project
```bash
# install/update Hex (Elixir package manager, like npm or pip)
mix local.hex --force

# install Phoenix creation scripts
mix archive.install hex phx_new --force
mix archive.install hex igniter_new --force

# create a new app
mix igniter.new petals_stack_tutorial --with phx.new --install ash,ash_phoenix,ash_postgres,live_svelte --yes

# go to your new app
cd petals_stack_tutorial/

# set elixir versions, this will create a .tool-versions file
asdf set erlang 29.0.2
asdf set elixir 1.20.2-otp-29
```

Run the database
```bash
# run Postgres via Docker
docker run -d \
  --name phx_db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_HOST_AUTH_METHOD=trust \
  -p 5432:5432 \
  postgres
```

Run the server
```bash
# install dependencies, run migrations
mix setup

# run the server
mix phx.server

# run the server and a console
iex -S mix phx.server
```

Optional, install additional packages (see more at https://ash-hq.org/#get-started)
```bash
mix igniter.install PACKAGE1 PACKAGE2 PACKAGE3
```

Here are some addtional packages I recommend:

- [`ash_authentication`](https://hex.pm/packages/ash_authentication): An extension for the Ash Framework providing turnkey user authentication, including password strategies, OAuth2, and token management.
- [`ash_json_api`](https://hex.pm/packages/ash_json_api): An Ash extension that automatically exposes your resources as a JSON:API-compliant REST interface.
- [`ash_graphql`](https://hex.pm/packages/ash_graphql): An Ash extension that generates Absinthe-powered GraphQL schemas and endpoints directly from your resources.
- [`ash_admin`](https://hex.pm/packages/ash_admin): An automatically generated administration UI for viewing, filtering, and mutating data across your Ash resources.
- [`ash_ai`](https://hex.pm/packages/ash_ai): A framework extension that brings LLM capabilities to Ash, supporting prompt-backed actions, vector embeddings, and Model Context Protocol (MCP) integrations.
- [`live_debugger`](https://hex.pm/packages/live_debugger): A browser-based development tool for inspecting component trees, viewing assigns, and tracing callback executions in Phoenix LiveView applications.
- [`tidewave`](https://hex.pm/packages/tidewave): An AI development toolkit by Dashbit that integrates runtime introspection, browser automation, and point-and-click UI tracing directly into Phoenix.

## 2: Intro to LiveView

In traditional Model-View-Controller architecture: HTTP requests are made to the server, HTML is rendered server-side, and returned without state.

In Phoenix LiveView: the initial HTTP request renders a static page quickly, then creates a WebSocket connection to update the client with the state on the server.

We'll make  a simple counter example.

First we need ot add the LiveView to the router.

```elixir
scope "/", PetalsStackTutorialWeb do
  pipe_through :browser

  # new example scope
  scope "/examples" do
    # new counter example
    live "/counter", CounterLive
  end
end
```

This will put our Live View at `/examples/counter`

Next ceate the `PetalsStackTutorialWeb.CounterLive` module in file `lib/petals_stack_tutorial_web/live/counter_live.ex`

```elixir
defmodule PetalsStackTutorialWeb.CounterLive do
  use PetalsStackTutorialWeb, :live_view
end
```

Next we need to implment 3 callbacks

- `mount/3` which is called when the WebSocket is mounted. Used to initial the view.
- `render/1` renders and returns the HTML.
- `handle_event/3` handles events emmited from the view.

For mount, we assign the value of "counter" to 0 in the socket.

```elixir
@impl true
def mount(_params, _session, socket) do
  {:ok, assign(socket, counter: 0)}
end
```

Next, return the view. For now we'll keep it inline as a string, but we could use a HEEx template.

```elixir
@impl true
def render(assigns) do
  ~H"""
  <div>
    <h1>Counter is {@counter}</h1>
    <button phx-click="inc" phx-debounce="20">+</button>
    <button phx-click="dec" phx-debounce="20">-</button>
  </div>
  """
end
```

The `counter` assignment is extracted from `assigns` with the "@" macro. The `phx-click` attribute sets the name of the event that is sent to the server when the button is clicked. The `phx-debounce="20"` attribute setting ensures the events debounce for 20 milliseconds.

Finally, handle the events.

```elixir
@impl true
def handle_event("inc", _payload, socket) do
  {:noreply, update(socket, :counter, fn x -> x + 1 end)}
end

def handle_event("dec", _payload, socket) do
  f = fn
    0 -> 0
    x -> x - 1
  end

  {:noreply, update(socket, :counter, f)}
end
```

We can lean on Elixir's pattern matching here. `handle_event/3` has a seperate clause for each event, and the decrement event function handles when trying to decrement 0. We use `update/3` function to pass a function and update the assignment, rather than reading the value and updating it.

The result is a view that is declaritive and only changed via state that is stored and changed server side.

## 3: Ash Authentication
