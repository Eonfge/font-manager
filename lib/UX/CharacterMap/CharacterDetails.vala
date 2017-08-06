/* CharacterDetails.vala
 *
 * Copyright (C) 2009 - 2016 Jerry Casiano
 *
 * This file is part of Font Manager.
 *
 * Font Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Font Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Font Manager.  If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.
 *
 * Author:
 *        Jerry Casiano <JerryCasiano@gmail.com>
*/

namespace FontManager {

    public class CharacterDetails : Gtk.EventBox {

        public unichar active_character {
            get {
                return ac;
            }
            set {
                ac = value;
                set_details();
            }
        }

        unichar ac;
        Gtk.Box box;
        Gtk.Label unicode_label;
        Gtk.Label name_label;

        public CharacterDetails () {
            box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            unicode_label = new Gtk.Label(null);
            unicode_label.halign = Gtk.Align.END;
            unicode_label.selectable = true;
            unicode_label.can_focus = false;
            name_label = new Gtk.Label(null);
            name_label.halign = Gtk.Align.START;
            name_label.opacity = unicode_label.opacity = 0.9;
            unicode_label.margin = name_label.margin = DEFAULT_MARGIN_SIZE / 4;
            box.pack_start(unicode_label, true, true, 2);
            box.pack_end(name_label, true, true, 2);
            add(box);
            get_style_context().add_class(Gtk.STYLE_CLASS_VIEW);
        }

        public override void show () {
            unicode_label.show();
            name_label.show();
            box.show();
            base.show();
            return;
        }

        void set_details () {
            unicode_label.set_markup(Markup.printf_escaped("<b>U+%4.4X</b>", ac));
            name_label.set_markup(Markup.printf_escaped("<b>%s</b>", Unicode.get_codepoint_name(ac)));
            return;
        }

    }

}
