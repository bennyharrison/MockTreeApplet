# MockTreeApplet

Early Prototype of a FatWire Content Server Tree Tab Java Applet Alternative

# Install

Place `MockTreeApplet.jsp` in root of `ElementCatalog`

Create a `SiteCatalog` record with `MockTreeApplet.jsp` rootelement and disable pageletonly

Place getTabs.sql and getTabsSect.sql in MockTreeApplet folder in `SystemSql`

Create a bookmarketlet

	javascript:void(parent['XcelWorkFrames']['XcelTree'].location.href='ContentServer?pagename=MockTreeApplet')
