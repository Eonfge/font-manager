/* font-manager-codepoint-list.c
 *
 * Copyright (C) 2009 - 2018 Jerry Casiano
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

#include "font-manager-codepoint-list.h"
#include "font-manager-database.h"
#include "font-manager-fontconfig.h"


struct _FontManagerCodepointList
{
    GObject parent_instance;

    GList *charset;
    GList *filter;
};

static void unicode_codepoint_list_interface_init (UnicodeCodepointListInterface *iface);

G_DEFINE_TYPE_WITH_CODE(FontManagerCodepointList, font_manager_codepoint_list, G_TYPE_OBJECT,
    G_IMPLEMENT_INTERFACE(UNICODE_TYPE_CODEPOINT_LIST, unicode_codepoint_list_interface_init))

enum
{
    PROP_0,
    PROP_FONT_OBJECT,
    PROP_FILTER
};

static gint
get_index (UnicodeCodepointList *_self, gunichar wc)
{
    g_return_val_if_fail(_self != NULL, -1);
    FontManagerCodepointList *self = FONT_MANAGER_CODEPOINT_LIST(_self);
    if (self->filter)
        return g_list_index(self->filter, &wc);
    return self->charset != NULL ? (gint) g_list_index(self->charset, &wc) : -1;
}

static gint
get_last_index (UnicodeCodepointList *_self)
{
    g_return_val_if_fail(_self != NULL, -1);
    FontManagerCodepointList *self = FONT_MANAGER_CODEPOINT_LIST(_self);
    if (self->filter)
        return g_list_length(self->filter);
    return self->charset != NULL ? (gint) g_list_length(self->charset) : -1;
}

static gunichar
get_char (UnicodeCodepointList *_self, gint index)
{
    g_return_val_if_fail(_self != NULL, (gunichar) -1);
    FontManagerCodepointList *self = FONT_MANAGER_CODEPOINT_LIST(_self);
    if (self->filter)
        return GPOINTER_TO_INT(g_list_nth_data(self->filter, index));
    return self->charset != NULL ?
           (gunichar) GPOINTER_TO_INT(g_list_nth_data(self->charset, index)) :
           (gunichar) -1;
}

static void
unicode_codepoint_list_interface_init (UnicodeCodepointListInterface *iface)
{
    iface->get_char = get_char;
    iface->get_index = get_index;
    iface->get_last_index = get_last_index;
    return;
}

static void
font_manager_codepoint_list_finalize (GObject *object)
{
    FontManagerCodepointList *self = FONT_MANAGER_CODEPOINT_LIST(object);
    if (self->charset)
        g_list_free(self->charset);
    if (self->filter)
        g_list_free(self->filter);
    G_OBJECT_CLASS(font_manager_codepoint_list_parent_class)->finalize(object);
    return;
}

static void
font_manager_codepoint_list_init (FontManagerCodepointList *self)
{
    self->charset = NULL;
    self->filter = NULL;
    return;
}

static void
font_manager_codepoint_list_set_property (GObject *object,
                                           guint prop_id,
                                           const GValue *value,
                                           GParamSpec *pspec)
{
    FontManagerCodepointList *self = FONT_MANAGER_CODEPOINT_LIST(object);

    switch (prop_id) {
        case PROP_FONT_OBJECT:
            font_manager_codepoint_list_set_font(self, g_value_get_boxed(value));
            break;
        case PROP_FILTER:
            font_manager_codepoint_list_set_filter(self, g_value_get_pointer(value));
            break;
        default:
            G_OBJECT_WARN_INVALID_PROPERTY_ID(object, prop_id, pspec);
            break;
    }
}

static void
font_manager_codepoint_list_class_init (FontManagerCodepointListClass *klass)
{
    GObjectClass *object_class = G_OBJECT_CLASS(klass);

    object_class->set_property = font_manager_codepoint_list_set_property;
    object_class->finalize = font_manager_codepoint_list_finalize;

    /**
     * FontManagerCodepointList:font: (type JsonObject) (transfer none)
     */
    g_object_class_install_property(object_class,
                                    PROP_FONT_OBJECT,
                                    g_param_spec_boxed("font",
                                                        NULL, NULL,
                                                        JSON_TYPE_OBJECT,
                                                        G_PARAM_WRITABLE |
                                                        G_PARAM_STATIC_NAME |
                                                        G_PARAM_STATIC_NICK |
                                                        G_PARAM_STATIC_BLURB));

    /**
     * FontManagerCodepointList:filter: (type GList(uint)) (transfer full)
     */
    g_object_class_install_property(object_class,
                                    PROP_FILTER,
                                    g_param_spec_pointer("filter",
                                                        NULL, NULL,
                                                        G_PARAM_WRITABLE |
                                                        G_PARAM_STATIC_NAME |
                                                        G_PARAM_STATIC_NICK |
                                                        G_PARAM_STATIC_BLURB));
    return;
}

/**
 * font_manager_codepoint_list_set_font:
 * @self:   #FontManagerCodepointList
 * @font: (transfer none) (nullable): #JsonObject
 *
 * Updates the codepoint list to contain only codepoints actually present in @font.
 */
void
font_manager_codepoint_list_set_font (FontManagerCodepointList *self, JsonObject *font)
{
    g_return_if_fail(self != NULL);
    GList *new_charset = NULL;
    if (font && json_object_ref(font)) {
        new_charset = get_charset_from_font_object(font);
        json_object_unref(font);
    }
    if (self->charset)
        g_list_free(self->charset);
    self->charset = NULL;
    self->charset = new_charset;
    return;
}

/**
 * font_manager_codepoint_list_set_filter:
 * @self: #FontManagerCodepointList
 * @filter: (element-type uint) (transfer none) (nullable): #GList containing codepoints
 *
 * When a filter is set only codepoints which are actually present in the filter
 * will be used.
 */
void
font_manager_codepoint_list_set_filter (FontManagerCodepointList *self, GList *filter)
{
    g_return_if_fail(self != NULL);
    GList *_filter = NULL;
    for (GList *iter = filter; iter != NULL; iter = iter->next)
        _filter = g_list_prepend(_filter, iter->data);
    _filter = g_list_reverse(_filter);
    if (self->filter)
        g_list_free(self->filter);
    self->filter = NULL;
    self->filter = _filter;
    return;
}

/**
 * font_manager_codepoint_list_new:
 *
 * Creates a new codepoint list
 *
 * Returns: (transfer full): the newly-created #FontManagerCodepointList.
 * Use g_object_unref() to free the result.
 **/
FontManagerCodepointList *
font_manager_codepoint_list_new ()
{
    return FONT_MANAGER_CODEPOINT_LIST(g_object_new(font_manager_codepoint_list_get_type(), NULL));
}

