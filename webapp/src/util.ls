$ = require(\jquery)

{ Varying } = require(\janus)
stdlib = require(\janus-stdlib)
{ from-event-now } = stdlib.util.varying


module.exports = util =
  defer: (f) -> set-timeout(f, 0)
  clamp: (min, max, x) --> if x < min then min else if x > max then max else x
  px: (x) -> "#{x}px"
  pct: (x) -> "#{x * 100}%"
  pad: (x) -> if x < 10 then "0#x" else x
  get-time: -> (new Date()).getTime()
  max-int: Number.MAX_SAFE_INTEGER

  size-of: (selector) ->
    dom = $(selector)
    from-event-now($(window), \resize, -> { width: dom.width(), height: dom.height() })

  bump: (varying) ->
    varying.set(true)
    <- util.defer
    varying.set(false)

  attach-floating-box: (initiator, view, box-class = 'floating-box') ->
    box = $('<div/>').addClass(box-class)
    box.append(view.artifact())

    box.appendTo($('body'))
    target-offset = initiator.offset()
    box.css(\left, Math.max(0, target-offset.left - box.outerWidth()))
    box.css(\top, target-offset.top)

    initiator.addClass(\active)
    is-hovered = new Varying(true)
    targets = initiator.add(box)
    targets.on(\mouseenter, -> is-hovered.set(true))
    targets.on(\mouseleave, -> is-hovered.set(false))
    stdlib.util.varying.sticky(is-hovered, { true: 100 }).react((hovered) ->
      if !hovered
        initiator.removeClass(\active)
        view.destroy()
        box.remove()
        this.stop()
    )

