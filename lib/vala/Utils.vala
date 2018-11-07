/* Utils.vala
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

namespace FontManager {

    public delegate void ReloadFunc ();
    public delegate void MenuCallback ();

    public enum DragTargetType {
        FAMILY,
        COLLECTION,
        EXTERNAL
    }

    public const Gdk.DragAction AppDragActions = Gdk.DragAction.COPY;

    public const Gtk.TargetEntry [] AppDragTargets = {
        { "font-family", Gtk.TargetFlags.SAME_APP, DragTargetType.FAMILY },
        { "text/uri-list", 0, DragTargetType.EXTERNAL }
    };

    public struct MenuEntry {
        public string action_name;
        public string display_name;
        public string detailed_action_name;
        public string? accelerator;
        public MenuCallbackWrapper method;

        public MenuEntry (string name, string label, string detailed_signal, string? accel, MenuCallbackWrapper cbw) {
            action_name = name;
            display_name = label;
            detailed_action_name = detailed_signal;
            accelerator = accel;
            method = cbw;
        }
    }

    public bool is_valid_source (JsonProxy? object) {
        return (object != null && object.source_object != null);
    }

    public class MenuCallbackWrapper {
        public MenuCallback run;
        public MenuCallbackWrapper (MenuCallback c) {
            run = () => { c(); };
        }
    }

    public void add_action_from_menu_entry (ActionMap map, MenuEntry entry) {
        var action = new SimpleAction(entry.action_name, null);
        action.activate.connect((a, p) => { entry.method.run(); } );
        map.add_action(action);
        return;
    }

}

public string get_localized_pangram () {
    return Pango.Language.get_default().get_sample_string();
}

public string get_localized_preview_text () {
    return DEFAULT_PREVIEW_TEXT.printf(get_localized_pangram());
}

public Pango.FontDescription get_font (Gtk.Widget widget, Gtk.StateFlags flags = Gtk.StateFlags.NORMAL) {
    Pango.FontDescription desc;
    var ctx = widget.get_style_context();
    ctx.save();
    ctx.set_state(flags);
    ctx.get(flags, "font", out desc);
    ctx.restore();
    return desc.copy();
}

public Gtk.Separator add_separator (Gtk.Box box,
                                    Gtk.Orientation orientation = Gtk.Orientation.VERTICAL,
                                    Gtk.PackType pack_type = Gtk.PackType.START) {
    var separator = new Gtk.Separator(orientation);
    switch (pack_type) {
        case Gtk.PackType.END:
            box.pack_end(separator, false, true, 0);
            break;
        default:
            box.pack_start(separator, false, true, 0);
            break;
    }
    separator.show();
    separator.get_style_context().add_class("thin-separator");
    return separator;
}

public void set_default_button_relief (Gtk.Container container) {
    foreach (Gtk.Widget widget in container.get_children())
        if (widget is Gtk.Button)
            ((Gtk.Button) widget).relief = Gtk.ReliefStyle.NONE;
    return;
}

public void cr_set_source_rgba (Cairo.Context cr, Gdk.RGBA color, double? alpha = null) {
    if (alpha == null)
        cr.set_source_rgba(color.red, color.green, color.blue, color.alpha);
    else
        cr.set_source_rgba(color.red, color.green, color.blue, alpha);
    return;
}

public bool remove_directory_tree_if_empty (File dir) {
    try {
        var enumerator = dir.enumerate_children(FileAttribute.STANDARD_NAME,
                                                FileQueryInfoFlags.NONE);
        if (enumerator.next_file() != null)
            return false;
        File parent = dir.get_parent();
        dir.delete();
        if (parent != null)
            remove_directory_tree_if_empty(parent);
        return true;
    } catch (Error e) {
        warning(e.message);
    }
    return false;
}

public bool remove_directory (File dir, bool recursive = true) {
    try {
        if (recursive) {
            FileInfo fileinfo;
            var enumerator = dir.enumerate_children(FileAttribute.STANDARD_NAME, FileQueryInfoFlags.NONE);
            while ((fileinfo = enumerator.next_file ()) != null) {
                try {
                    dir.get_child(fileinfo.get_name()).delete();
                } catch (Error e) {
                    remove_directory(dir.get_child(fileinfo.get_name()), recursive);
                }
            }
        }
        dir.delete();
        return true;
    } catch (Error e) {
        warning(e.message);
    }
    return false;
}
