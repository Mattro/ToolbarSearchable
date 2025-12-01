# .searchable in a .toolbar

I found a bug in iOS 26. This is a demo project that demonstrates it.

## The bug

In iOS 26, .searchable in a .toolbar appears to block interaction in a List when the List is rendered offscreen.

Build the main branch of this app. Tap back. The List will appear with some jank.
When you attempt to scroll list interaction will be locked - intermittently. 

- It only happens on the first launch, so kill/open the app to keep trying

Radar: [FB21218061](radar://FB21218061)

## The fix

On branch `the-fix`:

When rendering a thing off-screen, the button can't be in the bottom toolbar with the search field. Move it somewhere else.
