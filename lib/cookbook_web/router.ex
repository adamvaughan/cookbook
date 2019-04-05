defmodule CookbookWeb.Router do
  use CookbookWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CookbookWeb do
    pipe_through :browser

    get "/", RecipeController, :index

    resources("/recipes", RecipeController)
    post("/recipes/add-ingredient", RecipeController, :add_ingredient)
    post("/recipes/add-step", RecipeController, :add_step)
    put("/recipes/:id/add-ingredient", RecipeController, :add_ingredient)
    put("/recipes/:id/add-step", RecipeController, :add_step)

    resources("/plans", PlanController) do
      resources("/day/:day/meals", MealController, only: [:index, :new])
      resources("/meals", MealController, only: [:create])

      resources("/list", ListController, only: [:show, :delete], singleton: true)
    end

    resources("/lists", ListController, only: []) do
      resources("/items", ItemController, only: [:create])
    end

    resources("/meals", MealController, only: [:delete])
    resources("/items", ItemController, only: [:update])
  end

  # Other scopes may use custom stacks.
  # scope "/api", CookbookWeb do
  #   pipe_through :api
  # end
end
