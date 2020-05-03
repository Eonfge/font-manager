/* font-manager-utils.h
 *
 * Copyright (C) 2009 - 2020 Jerry Casiano
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


#ifndef __UTILS_H__
#define __UTILS_H__

#include <glib.h>
#include <gio/gio.h>

G_BEGIN_DECLS

gint font_manager_get_file_owner (const gchar *filepath) G_GNUC_PURE;
gint font_manager_natural_sort (const gchar *s1, const gchar *s2) G_GNUC_PURE;
gboolean font_manager_exists (const gchar *filepath) G_GNUC_PURE;
gboolean font_manager_is_dir (const gchar *filepath) G_GNUC_PURE;
gchar * font_manager_get_file_extension (const gchar *filepath) G_GNUC_PURE;
gchar * font_manager_get_local_time (void) G_GNUC_PURE;
gchar * font_manager_get_user_font_directory (void) G_GNUC_CONST;
gchar * font_manager_get_package_cache_directory (void) G_GNUC_CONST;
gchar * font_manager_get_package_config_directory (void) G_GNUC_CONST;
gchar * font_manager_get_user_fontconfig_directory (void) G_GNUC_CONST;
gchar * font_manager_str_replace (const gchar *str, const gchar *target, const gchar *replacement) G_GNUC_PURE;
gchar * font_manager_to_filename (const gchar *str) G_GNUC_PURE;
GSettings * font_manager_get_gsettings (const gchar *schema_id);

G_END_DECLS

#endif /* __UTILS_H__ */

