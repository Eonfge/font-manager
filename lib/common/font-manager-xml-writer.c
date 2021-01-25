/* font-manager-xml-writer.c
 *
 * Copyright (C) 2009 - 2021 Jerry Casiano
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.
 *
 * If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.
*/

#include <libxml/xmlwriter.h>

#include "font-manager-xml-writer.h"

/**
 * SECTION: font-manager-xml-writer
 * @short_description: Convenience class for generating Fontconfig xml files
 * @title: Xml Writer
 * @include: font-manager-xml-writer.h
 * @see_also: https://www.freedesktop.org/software/fontconfig/fontconfig-user.html
 *
 * Convenience class for generating fontconfig configuration files.
 */

struct _FontManagerXmlWriter
{
    GObject parent_instance;

    gchar *filepath;
    xmlTextWriter *writer;
};

G_DEFINE_TYPE(FontManagerXmlWriter, font_manager_xml_writer, G_TYPE_OBJECT)

enum
{
    PROP_RESERVED,
    PROP_FILEPATH,
    N_PROPERTIES
};

static GParamSpec *obj_properties[N_PROPERTIES] = { NULL, };

static const gchar *DOCTYPE = "<!DOCTYPE fontconfig SYSTEM \"urn:fontconfig:fonts.dtd\">\n";
static const gchar *DOCGEN = " Generated by Font Manager. Do NOT edit this file. ";
static const gchar *DOCROOT = "fontconfig";

static void
font_manager_xml_writer_set_default_options (FontManagerXmlWriter *self)
{
    xmlTextWriterSetIndent(self->writer, TRUE);
    xmlTextWriterSetIndentString(self->writer, (const xmlChar *) "  ");
    xmlTextWriterStartDocument(self->writer, NULL, NULL, NULL);
    xmlTextWriterWriteString(self->writer, (xmlChar *) DOCTYPE);
    xmlTextWriterWriteComment(self->writer, (xmlChar *) DOCGEN);
    xmlTextWriterStartElement(self->writer, (xmlChar *) DOCROOT);
    return;
}

static void
font_manager_xml_writer_reset (FontManagerXmlWriter *self)
{
    g_clear_pointer(&self->writer, xmlFreeTextWriter);
    g_clear_pointer(&self->filepath, g_free);
    return;
}

static void
font_manager_xml_writer_dispose (GObject *gobject)
{
    g_return_if_fail(gobject != NULL);
    font_manager_xml_writer_reset(FONT_MANAGER_XML_WRITER(gobject));
    G_OBJECT_CLASS(font_manager_xml_writer_parent_class)->dispose(gobject);
    return;
}

static void
font_manager_xml_writer_get_property (GObject *gobject,
                                      guint property_id,
                                      GValue *value,
                                      GParamSpec *pspec)
{
    g_return_if_fail(gobject != NULL);
    switch (property_id)
    {
        case PROP_FILEPATH:
            g_value_set_string(value, FONT_MANAGER_XML_WRITER(gobject)->filepath);
            break;
        default:
            G_OBJECT_WARN_INVALID_PROPERTY_ID(gobject, property_id, pspec);
            break;
    }
    return;
}

static void
font_manager_xml_writer_class_init (FontManagerXmlWriterClass *klass)
{
    GObjectClass *object_class = G_OBJECT_CLASS(klass);
    object_class->dispose = font_manager_xml_writer_dispose;
    object_class->get_property = font_manager_xml_writer_get_property;

    /**
     * FontManagerXmlWriter:filepath:
     *
     * Path to file.
     */
    obj_properties[PROP_FILEPATH] = g_param_spec_string("filepath",
                                                        NULL,
                                                        "Filepath",
                                                        NULL,
                                                        G_PARAM_STATIC_STRINGS |
                                                        G_PARAM_READABLE |
                                                        G_PARAM_EXPLICIT_NOTIFY);

    g_object_class_install_properties(object_class, N_PROPERTIES, obj_properties);
    return;
}

static void
font_manager_xml_writer_init (FontManagerXmlWriter *self)
{
    self->writer = NULL;
    self->filepath = NULL;
    return;
}

/**
 * font_manager_xml_writer_open:
 * @self:       a #FontManagerXmlWriter
 * @filepath:   filepath to open for editing
 *
 * Returns: %TRUE on success
 */
gboolean
font_manager_xml_writer_open (FontManagerXmlWriter *self, const gchar *filepath)
{
    g_return_val_if_fail(self != NULL, FALSE);
    g_return_val_if_fail(self->writer == NULL && self->filepath == NULL, FALSE);
    self->writer = xmlNewTextWriterFilename(filepath, FALSE);
    if (self->writer == NULL) {
        g_critical(G_STRLOC ": Error opening %s", filepath);
        return FALSE;
    }
    self->filepath = g_strdup(filepath);
    font_manager_xml_writer_set_default_options(self);
    return TRUE;
}

/**
 * font_manager_xml_writer_close:
 * @self:       a #FontManagerXmlWriter
 *
 * Save and close current document
 *
 * Returns: %TRUE if document was successfully saved
 */
gboolean
font_manager_xml_writer_close (FontManagerXmlWriter *self)
{
    g_return_val_if_fail(self != NULL, FALSE);
    g_return_val_if_fail(self->writer != NULL, FALSE);
    if (xmlTextWriterEndDocument(self->writer) < 0) {
        g_critical(G_STRLOC ": Error closing %s", self->filepath);
        return FALSE;
    }
    font_manager_xml_writer_reset(self);
    return TRUE;
}

/**
 * font_manager_xml_writer_discard:
 * @self:       a #FontManagerXmlWriter
 *
 * Close current document without saving.
 */
void
font_manager_xml_writer_discard (FontManagerXmlWriter *self)
{
    g_return_if_fail(self != NULL);
    font_manager_xml_writer_reset(self);
    return;
}

/**
 * font_manager_xml_writer_start_element:
 * @self:       a #FontManagerXmlWriter
 * @name:       element name
 *
 * Start an xml element.
 *
 * Returns: The number of bytes written (may be 0 because of buffering) or -1 in case of error.
 */
gint
font_manager_xml_writer_start_element (FontManagerXmlWriter *self, const gchar *name)
{
    g_return_val_if_fail(self != NULL, -1);
    g_return_val_if_fail(self->writer != NULL, -1);
    g_return_val_if_fail(name != NULL, -1);
    return xmlTextWriterStartElement(self->writer, (const xmlChar *) name);
}

/**
 * font_manager_xml_writer_end_element:
 * @self:       a #FontManagerXmlWriter
 *
 * End the current xml element.
 *
 * Returns: The number of bytes written (may be 0 because of buffering) or -1 in case of error.
 */
gint
font_manager_xml_writer_end_element (FontManagerXmlWriter *self)
{
    g_return_val_if_fail(self != NULL, -1);
    g_return_val_if_fail(self->writer != NULL, -1);
    return xmlTextWriterEndElement(self->writer);
}

/**
 * font_manager_xml_writer_write_element:
 * @self:       a #FontManagerXmlWriter
 * @name:       element name
 * @content:    element content
 *
 * Returns: The number of bytes written (may be 0 because of buffering) or -1 in case of error.
 */
gint
font_manager_xml_writer_write_element (FontManagerXmlWriter *self,
                                       const gchar *name,
                                       const gchar *content)
{
    g_return_val_if_fail(self != NULL, -1);
    g_return_val_if_fail(self->writer != NULL, -1);
    g_return_val_if_fail(name != NULL && content != NULL, -1);
    return xmlTextWriterWriteElement(self->writer, (const xmlChar *) name, (const xmlChar *) content);
}

/**
 * font_manager_xml_writer_write_attribute:
 * @self:       a #FontManagerXmlWriter
 * @name:       attribute name
 * @content:    attribute content
 *
 * Returns: The number of bytes written (may be 0 because of buffering) or -1 in case of error.
 */
gint
font_manager_xml_writer_write_attribute (FontManagerXmlWriter *self,
                                         const gchar *name,
                                         const gchar *content)
{
    g_return_val_if_fail(self != NULL, -1);
    g_return_val_if_fail(self->writer != NULL, -1);
    g_return_val_if_fail(name != NULL && content != NULL, -1);
    return xmlTextWriterWriteAttribute(self->writer, (const xmlChar *) name, (const xmlChar *) content);
}

/**
 * font_manager_xml_writer_add_assignment:
 * @self:       a #FontManagerXmlWriter
 * @a_name:     name of property to edit
 * @a_type:     type of the property
 * @a_val:      new value to assign
 *
 * Assign a new value to a Fontconfig property.
 * Valid types are int, double, bool and string.
 */
void
font_manager_xml_writer_add_assignment (FontManagerXmlWriter *self,
                                        const gchar *a_name,
                                        const gchar *a_type,
                                        const gchar *a_val)
{
    g_return_if_fail(self != NULL);
    g_return_if_fail(self->writer != NULL);
    g_return_if_fail(a_name != NULL && a_type != NULL && a_val != NULL);
    xmlTextWriterStartElement(self->writer, (xmlChar *) "edit");
    xmlTextWriterWriteAttribute(self->writer, (xmlChar *) "name", (xmlChar *) a_name);
    xmlTextWriterWriteAttribute(self->writer, (xmlChar *) "mode", (xmlChar *) "assign");
    xmlTextWriterWriteAttribute(self->writer, (xmlChar *) "binding", (xmlChar *) "strong");
    xmlTextWriterWriteElement(self->writer, (xmlChar *) a_type, (xmlChar *) a_val);
    xmlTextWriterEndElement(self->writer);
    return;
}

/**
 * font_manager_xml_writer_add_elements:
 * @self:       an #FontManagerXmlWriter
 * @e_type:     element type
 * @elements: (element-type utf8) (transfer none): a #GList
 *
 * Add simple elements to a fontconfig configuration file.
 */
void
font_manager_xml_writer_add_elements (FontManagerXmlWriter *self,
                                      const gchar *e_type,
                                      GList *elements)
{
    g_return_if_fail(self != NULL);
    g_return_if_fail(self->writer != NULL);
    g_return_if_fail(e_type != NULL);
    GList *iter;
    for (iter = elements; iter != NULL; iter = iter->next) {
        g_autofree gchar *element = g_markup_escape_text(g_strstrip(iter->data), -1);
        xmlTextWriterWriteElement(self->writer, (xmlChar *) e_type, (xmlChar *) element);
    }
    return;
}

/**
 * font_manager_xml_writer_add_patelt:
 * @self:       a #FontManagerXmlWriter
 * @p_name:     patelt name
 * @p_type:     patelt type
 * @p_val:      patelt value
 *
 * Write a valid fontconfig pattern elt.
 * Valid patelt types are int, double, string, bool and const.
 */
void
font_manager_xml_writer_add_patelt (FontManagerXmlWriter *self,
                                    const gchar *p_name,
                                    const gchar *p_type,
                                    const gchar *p_val)
{
    g_return_if_fail(self != NULL);
    g_return_if_fail(self->writer != NULL);
    g_return_if_fail(p_name != NULL && p_type != NULL && p_val != NULL);
    xmlTextWriterStartElement(self->writer, (xmlChar *) "pattern");
    xmlTextWriterStartElement(self->writer, (xmlChar *) "patelt");
    xmlTextWriterWriteAttribute(self->writer, (xmlChar *) "name", (xmlChar *) p_name);
    xmlTextWriterWriteElement(self->writer, (xmlChar *) p_type, (xmlChar *) p_val);
    xmlTextWriterEndElement(self->writer);
    xmlTextWriterEndElement(self->writer);
    return;
}

/**
 * font_manager_xml_writer_add_selections:
 * @self:               an #FontManagerXmlWriter
 * @selection_type:     acceptfont or rejectfont
 * @selections: (element-type utf8) (transfer none): a #GList containing font family names
 *
 * Whitelist or blacklist a #GList of font families.
 */
void
font_manager_xml_writer_add_selections (FontManagerXmlWriter *self,
                                        const gchar *selection_type,
                                        GList *selections)
{
    g_return_if_fail(self != NULL);
    g_return_if_fail(self->writer != NULL);
    g_return_if_fail(selection_type != NULL);
    xmlTextWriterStartElement(self->writer, (xmlChar *) "selectfont");
    xmlTextWriterStartElement(self->writer, (xmlChar *) selection_type);
    GList *iter;
    for (iter = selections; iter != NULL; iter = iter->next) {
        g_autofree gchar *element = g_markup_escape_text(iter->data, -1);
        font_manager_xml_writer_add_patelt(self, "family", "string", element);
    }
    xmlTextWriterEndElement(self->writer);
    xmlTextWriterEndElement(self->writer);
    return;
}

/**
 * font_manager_xml_writer_add_test_element:
 * @self:       an #FontManagerXmlWriter
 * @t_name:     fontconfig property to test
 * @t_test:     valid comparison operator
 * @t_type:     value type
 * @t_val:      value
 *
 * Valid comparison operators can be one of eq, not_eq, less, less_eq,
 * more, more_eq, contains or not_contains.
 * Valid value types are int, double, string, bool and const.
 */
void
font_manager_xml_writer_add_test_element (FontManagerXmlWriter *self,
                                          const gchar *t_name,
                                          const gchar *t_test,
                                          const gchar *t_type,
                                          const gchar *t_val)
{
    g_return_if_fail(self != NULL);
    g_return_if_fail(self->writer != NULL);
    g_return_if_fail(t_name != NULL && t_test != NULL && t_type != NULL && t_val != NULL);
    xmlTextWriterStartElement(self->writer, (xmlChar *) "test");
    xmlTextWriterWriteAttribute(self->writer, (xmlChar *) "name", (xmlChar *) t_name);
    xmlTextWriterWriteAttribute(self->writer, (xmlChar *) "compare", (xmlChar *) t_test);
    xmlTextWriterWriteElement(self->writer, (xmlChar *) t_type, (xmlChar *) t_val);
    xmlTextWriterEndElement(self->writer);
    return;
}

/**
 * font_manager_xml_writer_new:
 *
 * Returns: (transfer full): A newly created #FontManagerXmlWriter.
 * Free the returned object using #g_object_unref().
 **/
FontManagerXmlWriter *
font_manager_xml_writer_new (void)
{
    return g_object_new(FONT_MANAGER_TYPE_XML_WRITER, NULL);
}

