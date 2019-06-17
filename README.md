[WIP]

# usage
```
class YourSchema < GraphQL::Schema
  instrument(:field, Instrumentations::SwitchConnection.new)
end
```
