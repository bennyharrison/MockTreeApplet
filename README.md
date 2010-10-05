# MockTreeApplet

Early Prototype of a FatWire Content Server Tree Tab Java Applet Alternative

# Install

1. Place `MockTreeApplet.jsp` in root of `ElementCatalog`

2. Create a `SiteCatalog` record with `MockTreeApplet.jsp` rootelement and disable pageletonly

3. Create a bookmarklet!

	javascript:void(parent['XcelWorkFrames']['XcelTree'].location.href='ContentServer?pagename=MockTreeApplet')
