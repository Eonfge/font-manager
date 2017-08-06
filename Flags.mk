
AM_VALAFLAGS = \
	--target-glib 2.38 \
	--pkg gmodule-2.0 \
	--pkg glib-2.0 \
	--pkg gio-2.0 \
	--pkg gtk+-3.0 \
	--pkg gee-0.8 \
	--pkg json-glib-1.0 \
	--pkg libxml-2.0 \
	--pkg pango \
	--pkg sqlite3 \
	--vapidir=$(top_srcdir)/vapi \
	--pkg Unicode

AM_CFLAGS = \
	-w \
	-I$(top_srcdir)/lib/ \
	-I$(top_srcdir)/lib/Unicode \
	-DLOCALEDIR=\""$(localedir)"\" \
	$(XML_CFLAGS) \
	$(FREETYPE_CFLAGS) \
	$(FONTCONFIG_CFLAGS) \
	$(GOBJECT_CFLAGS) \
	$(GLIB_CFLAGS) \
	$(GMODULE_CFLAGS) \
	$(GIO_CFLAGS) \
	$(CAIRO_CFLAGS) \
	$(GTK_CFLAGS) \
	$(PANGO_CFLAGS) \
	$(PANGOCAIRO_CFLAGS) \
	$(PANGOFT2_CFLAGS) \
	$(GEE_CFLAGS) \
	$(GUCHARMAP_CFLAGS) \
	$(JSONGLIB_CFLAGS) \
	$(SQLITE3_CFLAGS)

AM_LDADD = \
	-lm \
	-lpthread \
	$(XML_LIBS) \
	$(FREETYPE_LIBS) \
	$(FONTCONFIG_LIBS) \
	$(GOBJECT_LIBS) \
	$(GLIB_LIBS) \
	$(GMODULE_LIBS) \
	$(GIO_LIBS) \
	$(CAIRO_LIBS) \
	$(GTK_LIBS) \
	$(PANGO_LIBS) \
	$(PANGOCAIRO_LIBS) \
	$(PANGOFT2_LIBS) \
	$(GEE_LIBS) \
	$(GUCHARMAP_LIBS) \
	$(JSONGLIB_LIBS) \
	$(SQLITE3_LIBS)
