import { QueryClient } from "@tanstack/react-query"
import { createRouter as createTanStackRouter } from "@tanstack/react-router"
import { setupRouterSsrQueryIntegration } from "@tanstack/react-router-ssr-query"
import { routeTree } from "./routeTree.gen"

export function getRouter() {
  // Created per router instance so each SSR request gets its own cache.
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: {
        // Keeps data dehydrated on the server from refetching on hydration.
        staleTime: 60 * 1000,
      },
    },
  })

  const router = createTanStackRouter({
    routeTree,
    context: { queryClient },

    scrollRestoration: true,
    defaultPreload: "intent",
    // Let TanStack Query own caching; loaders always defer to it.
    defaultPreloadStaleTime: 0,
  })

  // Wraps the app in QueryClientProvider and handles SSR
  // dehydration/hydration + streaming of queries.
  setupRouterSsrQueryIntegration({ router, queryClient })

  return router
}

declare module "@tanstack/react-router" {
  interface Register {
    router: ReturnType<typeof getRouter>
  }
}
