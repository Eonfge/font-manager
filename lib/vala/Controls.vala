/* Controls.vala
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

    public class LabeledControl : Gtk.Box {

        /**
         * LabeledControl:label:
         *
         * #GtkLabel
         */
        public Gtk.Label label { get; private set; }

        /**
         * LabeledControl:description:
         *
         * Centered #GtkLabel with dim-label style class
         */
        public Gtk.Label description { get; private set; }

        construct {
            margin = MINIMUM_MARGIN_SIZE * 8;
            label = new Gtk.Label(null);
            label.set("hexpand", false, "halign", Gtk.Align.START, null);
            description = new Gtk.Label(null);
            description.set("hexpand", true, "halign", Gtk.Align.CENTER, null);
            description.get_style_context().add_class(Gtk.STYLE_CLASS_DIM_LABEL);
            pack_start(label, false, false, 0);
            set_center_widget(description);
        }

        /**
         * {@inheritDoc}
         */
        public override void show () {
            label.show();
            description.show();
            base.show();
            return;
        }

    }

    /**
     * LabeledSwitch:
     * @label:      text to display in label or %NULL
     *
     * Row like widget containing two #GtkLabel and a #GtkSwitch.
     * Use #GtkLabel.set_text() / #GtkLabel.set_markup()
     * @label is intended to display main option name
     * @description is intended to display additional information
     * @toggle is #GtkSwitch connect to its active signal to monitor changes
     *
     * ------------------------------------------------------------
     * |                                                          |
     * | label                 description                switch  |
     * |                                                          |
     * ------------------------------------------------------------
     */
    public class LabeledSwitch : LabeledControl {

        /**
         * LabeledSwitch:toggle:
         *
         * #GtkSwitch
         */
        public Gtk.Switch toggle { get; private set; }

        public LabeledSwitch (string? label = null) {
            Object(name: "LabeledSwitch");
            this.label.set_text(label != null ? label : "");
            toggle = new Gtk.Switch();
            toggle.expand = false;
            pack_end(toggle, false, false, 0);
        }

        /**
         * {@inheritDoc}
         */
        public override void show () {
            toggle.show();
            base.show();
            return;
        }

    }

    /**
     * LabeledSpinButton:
     *
     * @label:      text to display in label
     * @min:        minimum value for #GtkSpinButton
     * @max:        maximum value for #GtkSpinButton
     * @step:       step increment for #GtkSpinButton.adjustment
     *
     * Row like widget containing a #GtkLabel and a #GtkSpinButton.
     *
     * ------------------------------------------------------------
     * |                                                          |
     * | label                                       spinbutton   |
     * |                                                          |
     * ------------------------------------------------------------
     */
    public class LabeledSpinButton : LabeledControl {

        /**
         * LabeledSpinButton:value:
         *
         * Current value.
         */
        public double @value { get; set; default = 0.0; }

        Gtk.SpinButton spin;

        public LabeledSpinButton (string? label, double min, double max, double step) {
            Object(name: "LabeledSpinButton");
            this.label.set_text(label != null ? label : "");
            spin = new Gtk.SpinButton.with_range(min, max, step);
            bind_property("value", spin, "value", BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);
            pack_end(spin, false, false, 0);
        }

        /**
         * {@inheritDoc}
         */
        public override void show () {
            spin.show();
            base.show();
            return;
        }

    }

    /**
     * LabeledFontButton:
     * @label:      text to display in label or %NULL
     *
     * Row like widget containing two #GtkLabel and a #GtkSwitch.
     * Use #GtkLabel.set_text() / #GtkLabel.set_markup()
     * @label is intended to display main option name
     * @description is intended to display additional information
     * @button is #GtkFontButton
     *
     * ------------------------------------------------------------
     * |                                                          |
     * | label                 description                button  |
     * |                                                          |
     * ------------------------------------------------------------
     */
    public class LabeledFontButton : LabeledControl {

        /**
         * LabeledFontButton:button:
         *
         * #GtkFontButton
         */
        public Gtk.FontButton button { get; private set; }

        public string font { get; set; default = DEFAULT_FONT; }

        public LabeledFontButton (string? label = null, string? font = null) {
            Object(name: "LabeledFontButton");
            this.label.set_text(label != null ? label : "");
            button = new Gtk.FontButton();
            button.set_use_font(true);
            pack_end(button, false, false, 0);
            bind_property("font", button, "font", BindingFlags.DEFAULT | BindingFlags.SYNC_CREATE);
        }

        /**
         * {@inheritDoc}
         */
        public override void show () {
            button.show();
            base.show();
            return;
        }

    }

    /**
     * OptionScale:
     *
     * @heading:    string to display centered above scale
     * @options:    string [] of options to create marks for
     *
     * Row like widget containing a #GtkLabel displayed centered
     * above the scale.
     *
     * ---------------------------------------------------------------
     * |                          heading                            |
     * |                                                             |
     * |   options[0] ---------- options[1] ----------- options[2]   |
     * |                                                             |
     * ---------------------------------------------------------------
     */
    public class OptionScale : Gtk.Grid {

        /**
         * OptionScale:value:
         *
         * Current value.
         */
        public double @value { get; set; default = 0.0; }

        /**
         * FontScale:adjustment:
         *
         * #GtkAdjustment in use
         */
        public Gtk.Adjustment adjustment {
            get {
                return scale.get_adjustment();
            }
        }

        /**
         * OptionScale:options:
         */
        public string [] options { get; private set; }

        Gtk.Label label;
        Gtk.Scale scale;

        public OptionScale (string? heading, string [] options) {
            Object(name: "OptionScale", hexpand: true, margin: DEFAULT_MARGIN_SIZE);
            /* private setter */
            this.options = options;
            scale = new Gtk.Scale.with_range(Gtk.Orientation.HORIZONTAL, 0, options.length - 1, 1.0);
            scale.set("hexpand", true, "draw-value", false, "round-digits", 1, "show-fill-level", false, null);
            double upper = ((double) options.length - 1);
            scale.adjustment.set("lower", 0.0, "page-increment", 1.0, "step-increment", 1.0, "upper", upper, null);
            for (int i = 0; i < options.length; i++)
                scale.add_mark(i, Gtk.PositionType.BOTTOM, options[i]);
            scale.value_changed.connect(() => {
                scale.set_value(Math.round(scale.adjustment.get_value()));
            });
            label = new Gtk.Label(heading);
            label.set("hexpand", true, "margin", margin / 2, null);
            attach(label, 0, 0, options.length, 1);
            attach(scale, 0, 1, options.length, 1);
            bind_property("value", scale.adjustment, "value", BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);
        }

        /**
         * {@inheritDoc}
         */
        public override void show () {
            label.show();
            scale.show();
            base.show();
            return;
        }

    }

    /**
     * FontScale:
     *
     * Row like widget which displays a #GtkScale and a #GtkSpinButton
     * for adjusting font display size.
     *
     * ------------------------------------------------------------------
     * |                                                                |
     * |  a  |------------------------------------------|  A   [  +/-]  |
     * |                                                                |
     * ------------------------------------------------------------------
     */
    public class FontScale : Gtk.EventBox {

        /**
         * FontScale:value:
         *
         * Current value.
         */
        public double @value { get; set; default = 0.0; }

        /**
         * FontScale:adjustment:
         *
         * #GtkAdjustment in use
         */
        public Gtk.Adjustment adjustment {
            get {
                return scale.get_adjustment();
            }
            set {
                scale.set_adjustment(value);
                spin.set_adjustment(value);
            }
        }

        Gtk.Box container;
        Gtk.Scale scale;
        Gtk.SpinButton spin;
        ReactiveLabel min;
        ReactiveLabel max;
        Gtk.Widget [] widgets;

        public FontScale () {
            Object(name: "FontScale");
            scale = new Gtk.Scale.with_range(Gtk.Orientation.HORIZONTAL, MIN_FONT_SIZE, MAX_FONT_SIZE, 0.5);
            scale.draw_value = false;
            scale.set_range(MIN_FONT_SIZE, MAX_FONT_SIZE);
            scale.set_increments(0.5, 1.0);
            spin = new Gtk.SpinButton.with_range(MIN_FONT_SIZE, MAX_FONT_SIZE, 0.5);
            spin.set_adjustment(adjustment);
            min = new ReactiveLabel(null);
            max = new ReactiveLabel(null);
            min.label.set_markup("<span font=\"Serif Italic Bold\" size=\"small\"> A </span>");
            max.label.set_markup("<span font=\"Serif Italic Bold\" size=\"large\"> A </span>");
            container = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);
            container.pack_start(min, false, true, 2);
            container.pack_start(scale, true, true, 0);
            container.pack_start(max, false, true, 2);
            container.pack_end(spin, false, true, 6);
            container.border_width = 5;
            add(container);
            min.clicked.connect(() => { scale.set_value(MIN_FONT_SIZE); });
            max.clicked.connect(() => { scale.set_value(MAX_FONT_SIZE); });
            bind_property("value", spin, "value", BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);
            widgets = { container, scale, spin, min, max };
        }

        /**
         * add_style_class:
         *
         * Convenience function which applies given style_class.
         */
        public void add_style_class (string gtk_style_class) {
            container.forall((w) => {
                if ((w is Gtk.SpinButton) || (w is Gtk.Scale))
                    return;
                w.get_style_context().add_class(gtk_style_class);
            });
            get_style_context().add_class(gtk_style_class);
            return;
        }

        /**
         * {@inheritDoc}
         */
        public override void show () {
            foreach (var widget in widgets)
                widget.show();
            base.show();
            return;
        }

    }

    /**
     * PreviewControls:
     *
     * Toolbar providing controls to justify, edit and reset preview text.
     *
     * -------------------------------------------------------------------
     * |                                                                 |
     * | justify controls           description             edit  reset  |
     * |                                                                 |
     * -------------------------------------------------------------------
     */
    public class PreviewControls : Gtk.EventBox {

        /**
         * PreviewControls::justification_set:
         *
         * Emitted when the user toggles justification
         */
        public signal void justification_set (Gtk.Justification justification);

        /**
         * PreviewControls::editing:
         *
         * Emitted when editing mode has changed.
         */
        public signal void editing (bool enabled);

        /**
         * PreviewControls::on_clear_clicked:
         *
         * Emitted when user has requested text be reset to default
         */
        public signal void on_clear_clicked ();

        /**
         * PreviewControls:clear_is_sensitive:
         *
         * Whether reset function is available.
         */
        public bool clear_is_sensitive {
            get {
                return clear.get_sensitive();
            }
            set {
                clear.set_sensitive(value);
            }
        }

        public string title {
            get {
                return description.get_text();
            }
            set {
                description.set_text(value);
            }
        }

        Gtk.Box box;
        Gtk.Label description;
        Gtk.Button clear;
        Gtk.ToggleButton edit;
        Gtk.RadioButton justify_left;
        Gtk.RadioButton justify_center;
        Gtk.RadioButton justify_fill;
        Gtk.RadioButton justify_right;
        Gtk.Widget [] widgets;

        construct {
            box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 2);
            box.border_width = 1;
            description = new Gtk.Label(null);
            description.set("sensitive", false, "halign", Gtk.Align.CENTER,
                            "hexpand", true, "vexpand", false, null);
            justify_left = new Gtk.RadioButton(null);
            justify_center = new Gtk.RadioButton.from_widget(justify_left);
            justify_fill = new Gtk.RadioButton.from_widget(justify_left);
            justify_right = new Gtk.RadioButton.from_widget(justify_left);
            justify_center.active = true;
            edit = new Gtk.ToggleButton();
            edit.set_image(new Gtk.Image.from_icon_name("insert-text-symbolic", Gtk.IconSize.MENU));
            edit.set_tooltip_text(_("Edit preview text"));
            edit.set("active", false, "relief", Gtk.ReliefStyle.NONE, null);
            clear = new Gtk.Button();
            clear.set_image(new Gtk.Image.from_icon_name("edit-undo-symbolic", Gtk.IconSize.MENU));
            clear.set_tooltip_text(_("Undo changes"));
            clear.set("sensitive", false, "relief", Gtk.ReliefStyle.NONE, null);
            Gtk.RadioButton [] buttons = { justify_left, justify_center, justify_fill, justify_right };
            string [] icons = { "format-justify-left-symbolic", "format-justify-center-symbolic",
                                 "format-justify-fill-symbolic", "format-justify-right-symbolic" };
            string [] tooltips = { _("Left Aligned"), _("Centered"), _("Fill"), _("Right Aligned") };
            for (int i = 0; i < buttons.length; i++) {
                var button = buttons[i];
                button.relief = Gtk.ReliefStyle.NONE;
                ((Gtk.ToggleButton) button).draw_indicator = false;
                button.get_style_context().add_class(Gtk.STYLE_CLASS_LINKED);
                button.set_image(new Gtk.Image.from_icon_name(icons[i], Gtk.IconSize.MENU));
                button.set_tooltip_text(tooltips[i]);
                box.pack_start(button, false, false, 0);
            }
            box.pack_end(clear, false, false, 0);
            box.pack_end(edit, false, false, 0);
            box.set_center_widget(description);
            add(box);
            get_style_context().add_class(Gtk.STYLE_CLASS_VIEW);
            connect_signals();
            widgets = { box, description, clear, edit, justify_left, justify_center, justify_fill, justify_right };
        }

        /**
         * {@inheritDoc}
         */
        public override void show () {
            foreach (var widget in widgets)
                widget.show();
            base.show();
            return;
        }

        void connect_signals () {
            justify_left.toggled.connect(() => { justification_set(Gtk.Justification.LEFT); });
            justify_center.toggled.connect(() => { justification_set(Gtk.Justification.CENTER); });
            justify_fill.toggled.connect(() => { justification_set(Gtk.Justification.FILL); });
            justify_right.toggled.connect(() => { justification_set(Gtk.Justification.RIGHT); });
            clear.clicked.connect(() => { on_clear_clicked(); });
            edit.toggled.connect(() => { editing(edit.get_active()); });
            return;
        }

    }

    /**
     * BaseControls:
     *
     * Base class for controls that allow adding or removing.
     * By default includes add/remove buttons packed at start of @box
     *
     * ----------------------------------------------------------------------
     * |  +  -                                                              |
     * ----------------------------------------------------------------------
     */
    public class BaseControls : Gtk.EventBox {

        /**
         * BaseControls::add_selected:
         *
         * Emitted when @add_button has been clicked
         */
        public signal void add_selected ();

        /**
         * BaseControls::remove_selected:
         *
         * Emitted when @remove_button is clicked
         */
        public signal void remove_selected ();

        /**
         * BaseControls:box:
         *
         * #GtkBox
         */
        public Gtk.Box box { get; protected set; }

        /**
         * BaseControls:add_button:
         *
         * #GtkButton
         */
        public Gtk.Button add_button { get; protected set; }

        /**
         * BaseControls:remove_button:
         *
         * #GtkButton
         */
        public Gtk.Button remove_button { get; protected set; }

        construct {
            box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4);
            box.border_width = 2;
            set_size_request(0, 0);
            add_button = new Gtk.Button();
            add_button.set_image(new Gtk.Image.from_icon_name("list-add-symbolic", Gtk.IconSize.MENU));
            remove_button = new Gtk.Button();
            remove_button.set_image(new Gtk.Image.from_icon_name("list-remove-symbolic", Gtk.IconSize.MENU));
            box.pack_start(add_button, false, false, 1);
            box.pack_start(remove_button, false, false, 1);
            set_default_button_relief(box);
            add(box);
            add_button.clicked.connect((w) => { add_selected(); });
            remove_button.clicked.connect(() => { remove_selected(); });
        }

        /**
         * {@inheritDoc}
         */
        public override void show () {
            add_button.show();
            remove_button.show();
            box.show();
            base.show();
            return;
        }

    }

    /**
     * SubpixelGeometry:
     *
     * https://en.wikipedia.org/wiki/Subpixel_rendering
     *
     * Widget allowing user to select pixel layout.
     */
    public class SubpixelGeometry : Gtk.Box {

        public int rgba {
            get {
                return _rgba;
            }
            set {
                if (value < 0 || value >= ((int) options.length()))
                    return;
                _rgba = value;
                options.nth_data(_rgba).active = true;
            }
        }

        public GLib.List <Gtk.RadioButton> options;

        int _rgba;
        Gtk.Label label;
        Gtk.ButtonBox box;

        public SubpixelGeometry () {

            Object(name: "SubpixelGeometry",
                    margin: DEFAULT_MARGIN_SIZE,
                    opacity: 0.75,
                    orientation: Gtk.Orientation.VERTICAL);

            label = new Gtk.Label(_("Subpixel Geometry"));
            label.set("halign", Gtk.Align.CENTER, "margin", DEFAULT_MARGIN_SIZE / 2, null);
            pack_start(label, false, true, 6);
            options = new GLib.List <Gtk.RadioButton> ();
            box = new Gtk.ButtonBox(Gtk.Orientation.HORIZONTAL);
            for (int i = 0; i < SubpixelOrder.NONE; i++) {
                if (i == 0)
                    options.append(new Gtk.RadioButton(null));
                else
                    options.append(new Gtk.RadioButton.from_widget(options.nth_data(0)));
                Gtk.RadioButton button = options.nth_data(i);
                var val = (SubpixelOrder) i;
                var icon = new SubpixelGeometryIcon(val);
                button.add(icon);
                icon.show();
                button.set_tooltip_text(val.to_string());
                button.toggled.connect(() => {
                    if (button.active)
                        rgba = (int) val;
                });
                box.pack_start(button);
            }
            pack_start(box, true, true, 6);
        }

        /**
         * {@inheritDoc}
         */
        public override void show () {
            foreach (var widget in options)
                widget.show();
            label.show();
            box.show();
            base.show();
            return;
        }

    }

}

