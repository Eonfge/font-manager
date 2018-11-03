/* Application.vala
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

    namespace FontViewer {

        const string BUS_ID = "org.gnome.FontViewer";
        const string BUS_PATH = "/org/gnome/FontViewer";

        [DBus (name = "org.gnome.FontViewer")]
        public class Application : Gtk.Application {

            [DBus (visible = false)]
            public MainWindow? main_window { get; private set; default = null; }

            uint dbus_id = 0;

            public Application (string app_id, ApplicationFlags app_flags) {
                Object(application_id : app_id, flags : app_flags);
            }

            public override void startup () {
                base.startup();
                main_window = new MainWindow();
                add_window(main_window);
                return;
            }

            public bool ready () {
                return main_window.ready();
            }

            public void show_uri (string uri) {
                main_window.show_uri(uri);
                activate();
                return;
            }

            public override void open (File [] files, string hint) {
                main_window.open(files[0].get_path());
                activate();
                return;
            }

            protected override void activate () {
                main_window.present();
                main_window.update();
                return;
            }

            public void about () {
                Gtk.show_about_dialog(main_window,
                                     "program-name", _("Font Viewer"),
                                     "logo-icon-name", About.ICON,
                                     "version", About.VERSION,
                                     "copyright", About.COPYRIGHT,
                                     "comments", About.COMMENT,
                                     "website", About.HOMEPAGE,
                                     "authors", About.AUTHORS,
                                     "license", About.LICENSE,
                                     "translator-credits", About.TRANSLATORS,
                                     null);
                return;
            }

            public override bool dbus_register (DBusConnection conn, string path) throws Error {
                base.dbus_register(conn, path);
                dbus_id = conn.register_object (BUS_PATH, this);
                if (dbus_id == 0)
                    critical("Could not register Font Viewer service ");
                return true;
            }

            public override void dbus_unregister (DBusConnection conn, string path) {
                if (dbus_id != 0)
                    conn.unregister_object(dbus_id);
                base.dbus_unregister(conn, path);
            }

            public static int main (string [] args) {
                GLib.Intl.bindtextdomain(Config.PACKAGE_NAME, null);
                GLib.Intl.bind_textdomain_codeset(Config.PACKAGE_NAME, null);
                GLib.Intl.textdomain(Config.PACKAGE_NAME);
                GLib.Intl.setlocale(GLib.LocaleCategory.ALL, null);
                Environment.set_application_name(_("Font Viewer"));
                Gtk.init(ref args);
                Gtk.IconTheme.get_default().add_resource_path("/org/gnome/FontManager/icons");
                return new Application(BUS_ID, (ApplicationFlags.HANDLES_OPEN)).run(args);
            }

        }

    }

}

