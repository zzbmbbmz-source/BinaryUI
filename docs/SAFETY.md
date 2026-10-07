# Defensive architecture

BinaryUI uses several independent boundaries:

- SafeCall catches callback failures.
- ErrorHandler records failures without stopping unrelated UI.
- ConnectionGuard owns and disconnects event connections.
- Cleanup destroys resources in reverse order.
- State ignores unchanged writes and protects observer dispatch.
- Registry prevents duplicate identifiers.
- Lifecycle makes destruction explicit and idempotent.
- Tween and optional integrations are isolated from core controls.

When adding a component, keep state private, validate inputs, guard callbacks, and make Destroy safe to call more than once.
