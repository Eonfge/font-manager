/* Substitutions.vala
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

    public class SubstitutionPreferences : FontConfigSettingsPage {

        BaseControls base_controls;
        SubstituteList sub_list;

        public SubstitutionPreferences () {
            orientation = Gtk.Orientation.VERTICAL;
            sub_list = new SubstituteList();
            sub_list.expand = true;
            base_controls = new BaseControls();
            base_controls.add_button.set_tooltip_text(_("Add alias"));
            base_controls.remove_button.set_tooltip_text(_("Remove selected alias"));
            base_controls.remove_button.sensitive = false;
            pack_start(base_controls, false, false, 1);
            add_separator(this, Gtk.Orientation.HORIZONTAL);
            pack_end(sub_list, true, true, 1);
            sub_list.load();
            connect_signals();
            get_style_context().add_class(Gtk.STYLE_CLASS_VIEW);
        }

        public override void show () {
            base_controls.show();
            base_controls.remove_button.hide();
            sub_list.show();
            base.show();
            return;
        }

        void connect_signals () {
            base_controls.add_selected.connect(() => {
                sub_list.on_add_row();
            });
            base_controls.remove_selected.connect(() => {
                sub_list.on_remove_row();
            });
            sub_list.row_selected.connect((r) => {
                if (r != null)
                    base_controls.remove_button.show();
                else
                    base_controls.remove_button.hide();
                base_controls.remove_button.sensitive = (r != null);
            });
            controls.save_selected.connect(() => {
                if (sub_list.save())
                    show_message(_("Settings saved to file."));
            });
            controls.discard_selected.connect(() => {
                if (sub_list.discard())
                    show_message(_("Removed configuration file."));
            });
            return;
        }

    }

    class SubstituteList : Gtk.ScrolledWindow {

        public signal void row_selected(Gtk.ListBoxRow? selected_row);

        Gtk.ListBox list;
        Gtk.ListStore completion_model;
        PlaceHolder welcome;

        construct {
            string w1 = _("Font Substitutions");
            string w2 = _("Easily substitute one font family for another.");
            string w3 = _("To add a new substitute click the add button in the toolbar.");
            string welcome_tmpl = "<span size=\"xx-large\" weight=\"bold\">%s</span>\n<span size=\"large\">\n\n%s\n</span>\n\n\n<span size=\"x-large\">%s</span>";
            string welcome_message = welcome_tmpl.printf(w1, w2, w3);
            welcome = new PlaceHolder(welcome_message, "edit-find-replace-symbolic");
            list = new Gtk.ListBox();
            list.set_placeholder(welcome);
            list.expand = true;
            add(list);
            list.row_selected.connect((r) => { row_selected(r); });
        }

        public override void show () {
            list.show();
            welcome.show();
            base.show();
            return;
        }

        public SubstituteList () {
            completion_model = new Gtk.ListStore(1, typeof(string));
            foreach (string family in list_available_font_families()) {
                Gtk.TreeIter iter;
                completion_model.append(out iter);
                completion_model.set(iter, 0, family, -1);
            }
        }

        public void on_add_row () {
            var row = new AliasRow();
            row.completion_model = completion_model;
            list.insert(row, -1);
            row.show();
            return;
        }

        public void on_remove_row () {
            ((Gtk.Widget) list.get_selected_row()).destroy();
            return;
        }

        public bool discard () {
            while (list.get_row_at_index(0) != null)
                ((Gtk.Widget) list.get_row_at_index(0)).destroy();
            var aliases = new Aliases();
            aliases.config_dir = get_user_fontconfig_directory();
            aliases.target_file = "39-Aliases.conf";
            File file = File.new_for_path(aliases.get_filepath());
            try {
                if (file.delete())
                    return true;
            } catch (Error e) {
                /* Try to save empty file */
                return save();
            }
            return false;
        }

        public bool load () {
            var aliases = new Aliases();
            aliases.config_dir = get_user_fontconfig_directory();
            aliases.target_file = "39-Aliases.conf";
            bool res = aliases.load();
            foreach (AliasElement element in aliases.list()) {
                var row = new AliasRow.from_element(element);
                row.completion_model = completion_model;
                list.insert(row, -1);
                row.show();
            }
            list.set_sort_func((row1, row2) => {
                var a = get_bin_child(row1) as AliasRow;
                var b = get_bin_child(row2) as AliasRow;
                return natural_sort(a.family, b.family);
            });
            list.invalidate_sort();
            return res;
        }

        public bool save () {
            var aliases = new Aliases();
            aliases.config_dir = get_user_fontconfig_directory();
            aliases.target_file = "39-Aliases.conf";
            int i = 0;
            var alias_row = get_bin_child(list.get_row_at_index(i)) as AliasRow;
            while (alias_row != null) {
                AliasElement? element = alias_row.to_element();
                /* Empty rows are allowed in the list - don't save one */
                if (element != null && element.family != null && element.family != "")
                    aliases.add_element(element);
                i++;
                alias_row = get_bin_child(list.get_row_at_index(i)) as AliasRow;
            }
            bool res = aliases.save();
            return res;
        }

        internal static Gtk.Widget? get_bin_child (Gtk.Widget? row) {
            if (row == null)
                return null;
            return ((Gtk.Bin) row).get_child();
        }

        class AliasRow : Gtk.Box {

            public string family {
                owned get {
                    return entry.get_text();
                }
                set {
                    entry.set_text(value);
                }
            }

            public Gtk.ListStore? completion_model {
                set {
                    Gtk.EntryCompletion completion = entry.get_completion();
                    completion.set_model(value);
                    completion.set_text_column(0);
                }
                get {
                    return entry.get_completion().get_model() as Gtk.ListStore;
                }
            }

            Gtk.Button add_button;
            Gtk.ButtonBox button_box;
            Gtk.Entry entry;
            Gtk.ListBox list;
            Gtk.Widget [] widgets;

            construct {
                orientation = Gtk.Orientation.VERTICAL;
                button_box = new Gtk.ButtonBox(Gtk.Orientation.HORIZONTAL);
                entry = new Gtk.Entry();
                entry.set_completion(new Gtk.EntryCompletion());
                entry.set_placeholder_text(_("Enter target family"));
                add_button = new Gtk.Button.from_icon_name("list-add-symbolic", Gtk.IconSize.BUTTON);
                add_button.set_tooltip_text(_("Add substitute"));
                add_button.expand = add_button.sensitive = false;
                list = new Gtk.ListBox();
                list.name = "SubstituteList";
                list.expand = true;
                list.set_selection_mode(Gtk.SelectionMode.NONE);
                list.margin = entry.margin = add_button.margin = MINIMUM_MARGIN_SIZE * 3;
                button_box.pack_start(entry);
                button_box.pack_end(add_button);
                pack_start(button_box, false, false, 0);
                add_separator(this, Gtk.Orientation.VERTICAL, Gtk.PackType.END);
                pack_end(list, true, false, 0);
                widgets = { add_button, button_box, entry, list };
            }

            /**
             * @families    List <string> of available font family names
             */
            public AliasRow () {
                Object(name: "AliasRow");
                connect_signals();
            }

            public AliasRow.from_element (AliasElement alias) {
                connect_signals();
                family = alias.family;
                string [] priorities = { "default", "accept", "prefer" };
                for (int i = 0; i < priorities.length; i++) {
                    foreach (string family in alias[priorities[i]].list()) {
                        Substitute sub = new Substitute();
                        sub.completion_model = completion_model;
                        sub.family = family;
                        sub.priority = priorities[i];
                        list.insert(sub, -1);
                        sub.show();
                    }
                }
            }

            public AliasElement to_element () {
                var res = new AliasElement(entry.get_text());
                int i = 0;
                var sub = get_bin_child(list.get_row_at_index(i)) as Substitute;
                while (sub != null) {
                    if (sub.family != null && sub.family != "")
                        res[sub.priority].add(sub.family);
                    i++;
                    sub = get_bin_child(list.get_row_at_index(i)) as Substitute;
                }
                return res;
            }

            public override void show () {
                foreach (var widget in widgets)
                    widget.show();
                base.show();
                return;
            }

            void connect_signals () {
                add_button.clicked.connect(() => {
                    var sub = new Substitute();
                    sub.completion_model = completion_model;
                    list.insert(sub, -1);
                    sub.show();
                });
                entry.changed.connect(() => {
                    add_button.sensitive = (entry.get_text() != null);
                });
                return;
            }

            /**
             * Substitute:
             *
             * Single line widget representing a substitute font family
             * in a Fontconfig <alias> entry.
             */
            class Substitute : Gtk.Grid {

                /**
                 * Substitute:priority:
                 *
                 * prefer, accept, or default
                 */
                public string priority {
                    owned get {
                        return type.get_active_text();
                    }
                    set {
                        var e = get_bin_child(type) as Gtk.Entry;
                        e.set_text(value);
                    }
                }

                /**
                 * Substitute:family:
                 *
                 * Name of replacement family
                 */
                public string? family {
                    owned get {
                        return target.get_text();
                    }
                    set {
                        target.set_text(value);
                    }
                }

                public Gtk.ListStore? completion_model {
                    set {
                        Gtk.EntryCompletion completion = target.get_completion();
                        completion.set_model(value);
                        completion.set_text_column(0);
                    }
                }

                Gtk.Button close;
                Gtk.ComboBoxText type;
                Gtk.Entry target;

                public Substitute () {
                    Object(name: "Substitute", hexpand: true, halign: Gtk.Align.CENTER);
                    type = new Gtk.ComboBoxText.with_entry();
                    type.append_text(_("prefer"));
                    type.append_text(_("accept"));
                    type.append_text(_("default"));
                    type.set("active", 0, "expand", false, "halign", Gtk.Align.START,
                              "margin", MINIMUM_MARGIN_SIZE * 3, null);
                    target = new Gtk.Entry();
                    target.set_completion(new Gtk.EntryCompletion());
                    target.set_placeholder_text(_("Enter substitute family"));
                    target.set("expand", false, "halign", Gtk.Align.CENTER,
                              "margin", MINIMUM_MARGIN_SIZE * 3, null);
                    close = new Gtk.Button();
                    close.set_image(new Gtk.Image.from_icon_name("window-close-symbolic", Gtk.IconSize.MENU));
                    close.set("expand", false, "halign", Gtk.Align.END, "margin", MINIMUM_MARGIN_SIZE * 3, null);
                    close.set_tooltip_text(_("Remove substitute"));
                    attach(type, 0, 0, 2, 1);
                    attach(target, 2, 0, 2, 1);
                    attach(close, 4, 0, 1, 1);
                    close.clicked.connect(() => {
                        this.destroy();
                        return;
                    });
                }

                public override void show () {
                    type.show();
                    target.show();
                    close.show();
                    base.show();
                }

            }

        }

    }

}
