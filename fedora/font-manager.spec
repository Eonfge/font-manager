%global MajorVersion 0
%global MinorVersion 7
%global MicroVersion 4
%global DBusName org.gnome.FontManager
%global DBusName2 org.gnome.FontViewer
%global Master https://github.com/FontManager/master
%global Releases %{Master}/releases/download

# Disable automatic compilation of Python files in extra directories
%undefine __brp_python_bytecompile
%global _python_bytecompile_extra 0

Name:       font-manager
Version:    %{MajorVersion}.%{MinorVersion}.%{MicroVersion}
Release:    12
Summary:    A simple font management application for Gtk+ Desktop Environments
License:    GPLv3+
Url:        http://fontmanager.github.io/
Source0:    %{Releases}/%{version}/%{name}-%{version}.tar.bz2

BuildRequires: fontconfig-devel
BuildRequires: freetype-devel
BuildRequires: glib2-devel
BuildRequires: gobject-introspection-devel
BuildRequires: gtk3-devel >= 3.22
BuildRequires: json-glib-devel
BuildRequires: libappstream-glib
BuildRequires: libxml2-devel
BuildRequires: pango-devel
BuildRequires: sqlite-devel
BuildRequires: vala >= 0.24
BuildRequires: yelp-tools
BuildRequires: /usr/bin/python
BuildRequires: python2-devel python3-devel

Requires: fontconfig
Requires: font-manager-common
Requires: font-viewer
Requires: freetype
Requires: gtk3 >= 3.22
Requires: sqlite
Requires: yelp

%description
Font Manager is intended to provide a way for average users to easily
 manage desktop fonts, without having to resort to command line tools
 or editing configuration files by hand. While designed primarily with
 the Gnome Desktop Environment in mind, it should work well with other
 Gtk+ desktop environments.

Font Manager is NOT a professional-grade font management solution.

%package -n %{name}-common
Summary: Common files used by font-manager
%description -n %{name}-common
This package contains common files such as libraries, help files,
 translations, etc.
 These files are required by font-manager and font-viewer.

%package -n font-viewer
Summary: Full featured font file preview application for GTK+ Desktop Environments
Requires: font-manager-common >= %{version}
%description -n font-viewer
This package contains the font-viewer component of font-manager.

%package -n nautilus-font-manager
BuildArch: noarch
Summary: Nautilus extension for font-manager
Requires: font-viewer >= %{version}
Requires: font-manager-common >= %{version}
Requires: nautilus-python
Requires: dbus-python
%description -n nautilus-font-manager
This package provides integration with the Nautilus file manager.

%package -n nemo-font-manager
BuildArch: noarch
Summary: Nemo extension for Font Manager
Requires: font-viewer >= %{version}
Requires: font-manager-common >= %{version}
Requires: nemo-python
Requires: dbus-python
%description -n nemo-font-manager
This package provides integration with the Nemo file manager.

%package -n thunarx-font-manager
BuildArch: noarch
Summary: Thunar extension for Font Manager
Requires: font-viewer >= %{version}
Requires: font-manager-common >= %{version}
Requires: thunarx-python
Requires: dbus-python
%description -n thunarx-font-manager
This package provides integration with the Thunar file manager.

%prep
%setup -q

%build
%configure --disable-schemas-compile --disable-pycompile --with-nautilus --with-nemo --with-thunarx
%make_build

%check
appstream-util validate-relax --nonet %{buildroot}/%{_datadir}/metainfo/*.appdata.xml

%install
%make_install
%py_byte_compile %{__python} %{buildroot}%{_datadir}/nautilus-python/extensions/
%py_byte_compile %{__python} %{buildroot}%{_datadir}/nemo-python/extensions/
%py_byte_compile %{__python} %{buildroot}%{_datadir}/thunarx-python/extensions/
%find_lang %name

%posttrans
/usr/bin/glib-compile-schemas %{_datadir}/glib-2.0/schemas &> /dev/null || :

%files
%{_bindir}/%{name}
%{_datadir}/metainfo/%{DBusName}.appdata.xml
%{_datadir}/applications/%{DBusName}.desktop
%{_datadir}/dbus-1/services/%{DBusName}.service
%{_datadir}/glib-2.0/schemas/%{DBusName}.gschema.xml
%{_mandir}/man1/%{name}.*

%files -n %{name}-common -f %{name}.lang
%doc README
%{_libdir}/%{name}
%{_datadir}/help/*/%{name}

%files -n font-viewer
%{_libexecdir}/%{name}/font-viewer
%{_datadir}/metainfo/%{DBusName2}.appdata.xml
%{_datadir}/applications/%{DBusName2}.desktop
%{_datadir}/dbus-1/services/%{DBusName2}.service
%{_datadir}/glib-2.0/schemas/%{DBusName2}.gschema.xml

%files -n nautilus-font-manager
%{_datadir}/nautilus-python/extensions/%{name}.py*

%files -n nemo-font-manager
%{_datadir}/nemo-python/extensions/%{name}.py*

%files -n thunarx-font-manager
%{_datadir}/thunarx-python/extensions/%{name}.py*

%changelog
* Thu Dec 20 2018 JerryCasiano <JerryCasiano@gmail.com> 0.7.4-12
- (Font Viewer) Fix dbus path
- Classify ttc as Opentype instead of CFF
* Thu Dec 13 2018 JerryCasiano <JerryCasiano@gmail.com> 0.7.4-11
- Improve appearance when client side decorations are disabled
- Add custom preview entry to browse and compare modes
* Tue Nov 27 2018 JerryCasiano <JerryCasiano@gmail.com> 0.7.4-10
- Add option to disable toolkit animations
- Add option to use dark theme if available
- Fix capitalization in preference dialogs
* Tue Nov 27 2018 JerryCasiano <JerryCasiano@gmail.com> 0.7.4-9
- Add preference pane for Gnome desktop settings.
- Add GtkShortcutsWindow.
- Remove Intltool.
- Fix functions which list font directories.
- Fix typos in help documents.
* Tue Nov 20 2018 JerryCasiano <JerryCasiano@gmail.com> 0.7.4-8
- Show progress when exporting collections.
- Avoid unnecessary updates to previews.
* Sun Nov 11 2018 JerryCasiano <JerryCasiano@gmail.com> 0.7.4-7
- Search filepath if search term starts with /
- Update help documents.
- Fix category count updates.
- Fix rendering issue with some themes by setting style class on preview stack.
* Thu Nov 08 2018 JerryCasiano <JerryCasiano@gmail.com> 0.7.4-6
- Remove some unnecessary updates to font list and categories.
* Tue Nov 06 2018 JerryCasiano <JerryCasiano@gmail.com> 0.7.4-5
- Use Pango generated font descriptions - bump database version.
- Disable user fontconfig files to prevent rendering glitches.
* Sat Nov 03 2018 JerryCasiano <JerryCasiano@gmail.com> 0.7.4-4
- Update vendor list
- Update Unicode version
- Fix Browse mode titles to display family name rather than default description
* Sat Nov 03 2018 JerryCasiano <JerryCasiano@gmail.com> 0.7.4-3
- Disable deprecated Gdk and Gtk symbols.
- Remove unused code.
* Thu Nov 01 2018 JerryCasiano <JerryCasiano@gmail.com> 0.7.4-2
- Ensure that collections are selected on first switch.
- Ensure that Unsorted/Disabled categories update as needed.
* Sun Oct 28 2018 JerryCasiano <JerryCasiano@gmail.com> 0.7.4-1
- Too many changes to list here. See CHANGELOG for details
* Sun Aug 6 2017 JerryCasiano <JerryCasiano@gmail.com> 0.7.3-11
- Drop dependence on Gucharmap
* Sun Jun 11 2017 JerryCasiano <JerryCasiano@gmail.com> 0.7.3-10
- Fix build failure with Vala 0.36 due to vapi changes
- Fix an issue where sources fail to add if a child directory has
  already been added.
- Add Russian translation provided by TotalCaesar659
- Sync translations from Zanata
* Sun Oct 16 2016 JerryCasiano <JerryCasiano@gmail.com> 0.7.3-9
- Fix extension requirements
* Sat Jun 4 2016 JerryCasiano <JerryCasiano@gmail.com> 0.7.3-8
- Fix initial window size issue on Gtk+ > 3.18
* Wed Jun 1 2016 JerryCasiano <JerryCasiano@gmail.com> 0.7.3-7
- Add Polish translation provided by Piotr Strębski
* Thu May 26 2016 JerryCasiano <JerryCasiano@gmail.com> 0.7.3-6
- Add manual page
* Thu Apr 21 2016 JerryCasiano <JerryCasiano@gmail.com> 0.7.3-5
- Drop build deps for python extensions
- Enable all extensions
- Update to latest git
* Sat Mar 5 2016 JerryCasiano <JerryCasiano@gmail.com> 0.7.3-4
- Update to latest git to include new features.
- Added preference pane.
* Wed Jan 06 2016 JerryCasiano <JerryCasiano@gmail.com> 0.7.3-3
- Update to latest git to include bug fixes.
* Wed Dec 23 2015 JerryCasiano <JerryCasiano@gmail.com> 0.7.3-2
- Leigh Scott enabled nemo extension for actual Fedora package
- Must *work* on Cinnamon...
* Tue Dec 8 2015 JerryCasiano <JerryCasiano@gmail.com> 0.7.3-1
- Update to testing branch 0.7.3
* Sat Jun 06 2015 JerryCasiano <JerryCasiano@gmail.com> 0.7.2-5
- Add missing Requires for Nautilus extension.
* Sat Jun 06 2015 JerryCasiano <JerryCasiano@gmail.com> 0.7.2-4
- Add missing BuildRequires for file-roller. Fails to mock.
* Tue Jun 02 2015 JerryCasiano <JerryCasiano@gmail.com> 0.7.2-3
- Adhere to https://fedoraproject.org/wiki/Packaging:AppData
* Thu May 28 2015 JerryCasiano <JerryCasiano@gmail.com> 0.7.2-2
- Add missing Requires
* Sun Jan 25 2015 JerryCasiano <JerryCasiano@gmail.com> 0.7.2-1
- Update to 0.7.2
* Sat Dec 13 2014 JerryCasiano <JerryCasiano@gmail.com> 0.7.1-1
- Initial build.


