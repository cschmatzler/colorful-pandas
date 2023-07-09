defmodule ColorfulPandas.Auth.Impl do
  @moduledoc """
  The default implementation of `ColorfulPandas.Auth`.
  """

  @behaviour ColorfulPandas.Auth

  import Ecto.Changeset
  import Ecto.Query

  alias ColorfulPandas.Auth.Identity
  alias ColorfulPandas.Auth.Organization
  alias ColorfulPandas.Auth.OrganizationInvite
  alias ColorfulPandas.Auth.Session
  alias ColorfulPandas.Auth.SignupFlow
  alias ColorfulPandas.Repo

  # Signup
  # ------
  @impl ColorfulPandas.Auth
  def get_signup_flow(id, opts \\ []) do
    preload = Keyword.get(opts, :preload, [])

    Repo.one(from(sf in SignupFlow, where: sf.id == ^id, preload: ^preload))
  end

  @impl ColorfulPandas.Auth
  def get_signup_flow_with_oauth(provider, uid) do
    provider
    |> SignupFlow.with_oauth_query(uid)
    |> Repo.one()
  end

  @impl ColorfulPandas.Auth
  def create_signup_flow(provider, uid, email, name, invite_id \\ nil) do
    %{provider: provider, uid: uid, email: email, name: name, invite_id: invite_id}
    |> SignupFlow.changeset()
    |> Repo.insert()
  end

  @impl ColorfulPandas.Auth
  def update_signup_flow(%SignupFlow{} = flow, changes) do
    flow
    |> SignupFlow.changeset(changes)
    |> Repo.update()
  end

  # OrganizationInvite
  # ------------------
  @impl ColorfulPandas.Auth
  def get_organization_invite_by_token(token, opts \\ []) do
    preload = Keyword.get(opts, :preload, [])

    OrganizationInvite.with_token_query(token)
    |> preload(^preload)
    |> Repo.one()
  end

  @impl ColorfulPandas.Auth
  def create_organization_invite(%Organization{id: id} = organization, %Identity{organization_id: id} = created_by) do
    token = OrganizationInvite.generate_token()

    %{token: token, organization_id: organization.id, created_by_id: created_by.id}
    |> OrganizationInvite.changeset()
    |> Repo.insert()
  end

  # Organization
  # ------------

  @impl ColorfulPandas.Auth
  def list_organizations do
    Repo.all(Organization)
  end

  # Identity
  # --------
  @impl ColorfulPandas.Auth
  def get_identity_with_oauth(provider, uid) do
    provider
    |> Identity.with_oauth_query(uid)
    |> Repo.one()
  end

  @impl ColorfulPandas.Auth
  def get_identity_with_session_token(token) do
    token
    |> Identity.with_session_token_query()
    |> Repo.one()
  end

  @impl ColorfulPandas.Auth
  def create_identity_from_flow(%SignupFlow{invite: %OrganizationInvite{} = invite} = flow) do
    identity_changes = %{provider: flow.provider, uid: flow.uid, email: flow.email, name: flow.name, organization_id: invite.organization_id}

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:identity, Identity.changeset(identity_changes))
    |> Ecto.Multi.update(:invite, fn _ ->
      change(invite, %{accepted_at: DateTime.utc_now()})
    end)
    |> Ecto.Multi.delete(:signup_flow, flow)
    |> Repo.transaction()
  end

  def create_identity_from_flow(%SignupFlow{invite: nil} = flow) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:organization, Organization.changeset(%{name: flow.organization_name}))
    |> Ecto.Multi.insert(:identity, fn %{organization: organization} ->
      Identity.changeset(%{provider: flow.provider, uid: flow.uid, email: flow.email, name: flow.name, organization_id: organization.id})
    end)
    |> Ecto.Multi.delete(:signup_flow, flow)
    |> Repo.transaction()
  end

  # Session
  # -------
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
