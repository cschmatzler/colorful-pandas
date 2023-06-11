defmodule ColorfulPandas.Auth.Impl do
  @moduledoc """
  The default implementation of `ColorfulPandas.Auth`.
  """

  @behaviour ColorfulPandas.Auth

  alias ColorfulPandas.Auth.SessionToken
  alias ColorfulPandas.Auth.User
  alias ColorfulPandas.Repo

  @impl ColorfulPandas.Auth
  def get_user_with_oauth(provider, uid) do
    provider
    |> User.with_oauth_query(uid)
    |> Repo.one()
  end

  @impl ColorfulPandas.Auth
  def get_user_with_session_token(token) do
    token
    |> SessionToken.user_with_payload_query()
    |> Repo.one()
  end

  @impl ColorfulPandas.Auth
  def create_signup_flow(_provider, _uid, _email) do
  end

  @impl ColorfulPandas.Auth
  def create_user(provider, uid, email, name, image_url) do
    %{
      provider: provider,
      uid: uid,
      email: email,
      name: name,
      image_url: image_url
    }
    |> User.changeset()
    |> Repo.insert()
  end

  @impl ColorfulPandas.Auth
  def create_session_token!(user_id) do
    user_id
    |> SessionToken.build()
    |> Repo.insert!()
  end

  @impl ColorfulPandas.Auth
  def delete_session_token(token_payload) do
    token_payload
    |> SessionToken.with_payload_query()
    |> Repo.delete_all()

    :ok
  end
end
