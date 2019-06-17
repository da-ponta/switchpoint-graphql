module Instrumentations
  class SwitchConnection
    def instrument(type, field)
      old_resolve_proc = field.resolve_proc
      new_resolve_proc = lambda do |obj, args, ctx|
        wrap_proc(obj, args, ctx, old_resolve_proc)
      end

      old_lazy_resolve_proc = field.lazy_resolve_proc

      new_lazy_resolve_proc = lambda do |obj, args, ctx|
        wrap_proc(obj, args, ctx, old_lazy_resolve_proc)
      end

      # Return a copy of `field`, with a new resolve proc
      field.redefine do
        resolve(new_resolve_proc)
        lazy_resolve(new_lazy_resolve_proc)
      end
    end

    def wrap_proc(object, arguments, context, old_proc)
      return old_proc.call(object, arguments, context) unless context.query.mutation?
      ApplicationRecord.with_writable do
        old_proc.call(object, arguments, context)
      end
    end
  end
end
