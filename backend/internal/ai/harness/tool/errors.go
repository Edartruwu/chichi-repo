package tool

import (
	"net/http"

	"github.com/Edartruwu/chichi-repo/backend/internal/errx"
)

// Registry holds the error codes for the harness tool layer.
var errRegistry = errx.NewRegistry("HARNESS_TOOL")

var (
	ErrUnknownTool = errRegistry.Register(
		"UNKNOWN_TOOL",
		errx.TypeNotFound,
		http.StatusNotFound,
		"Unknown tool",
	)

	ErrInvalidInput = errRegistry.Register(
		"INVALID_INPUT",
		errx.TypeValidation,
		http.StatusBadRequest,
		"Invalid tool input",
	)
)
