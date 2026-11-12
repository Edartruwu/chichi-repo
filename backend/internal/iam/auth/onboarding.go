package auth

import (
	"context"

	"github.com/Edartruwu/chichi-repo/backend/internal/iam/tenant"
	"github.com/Edartruwu/chichi-repo/backend/internal/iam/user"
)

// InvitationAcceptor atomically completes verified onboarding: membership,
// authentication method, scopes, role assignment, tenant count and invitation.
// The caller must verify the candidate's email identity before calling Accept.
type InvitationAcceptor interface {
	Accept(ctx context.Context, token string, candidate user.User) (*user.User, *tenant.Tenant, error)
}
