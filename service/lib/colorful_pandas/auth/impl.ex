defmodule ColorfulPandas.Auth.Impl do
  @moduledoc """
  The default implementation of `ColorfulPandas.Auth`.
  """

  @behaviour ColorfulPandas.Auth

  import Ecto.Changeset

  alias ColorfulPandas.Auth.Identity
  alias ColorfulPandas.Auth.Session
  alias ColorfulPandas.Auth.SignupFlow
  alias ColorfulPandas.Repo

  @impl ColorfulPandas.Auth
  def get_signup_flow(id) do
    Repo.get(SignupFlow, id)
  end

  @impl ColorfulPandas.Auth
  def get_identity_with_oauth(provider, uid) do
    provider
    |> Identity.with_oauth_query(uid)
    |> Repo.one()
  end

  @impl ColorfulPandas.Auth
  def get_identity_with_session_token(token) do
    token
    |> Session.identity_with_token_query()
    |> Repo.one()
  end

  @impl ColorfulPandas.Auth
  def create_signup_flow(provider, uid, email, name, invite_id) do
    %SignupFlow{}
    |> change(%{provider: provider, uid: uid, email: email, name: name, invite_id: invite_id})
    |> validate_required([:provider, :uid, :email, :name])
    |> unsafe_validate_unique([:provider, :uid], ColorfulPandas.Repo)
    |> unique_constraint([:provider, :uid])
    |> Repo.insert()
  end

  @impl ColorfulPandas.Auth
  def create_identity(provider, uid, email, name, image_url) do
    %{
      provider: provider,
      uid: uid,
      email: email,
      name: name,
      image_url: image_url
    }
    |> Identity.changeset()
    |> Repo.insert()
  end

  @impl ColorfulPandas.Auth
  def create_session!(identity_id) do
    identity_id
    |> Session.build()
    |> Repo.insert!()
  end

  @impl ColorfulPandas.Auth
  def delete_session(token) do
    token
    |> Session.with_token_query()
    |> Repo.delete_all()

    :ok
  end
end
