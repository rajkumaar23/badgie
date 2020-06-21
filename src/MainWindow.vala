/*
* Copyright (c) 2020 Rajkumar S (http://rajkumaar.co.in)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
*/

using Gtk;
using Soup;

public class MainWindow : ApplicationWindow {

    private Entry search_entry;
    private Label error_view;
    private Button button;
    private Button copy_source;
    private ComboBox types;
    private Grid grid;
    private Image image;
    private string[] types_array;
    private Gee.HashMap<string, string> type_map;
    private string API_URL;
    private string API_REPO;

    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            icon_name: "com.github.rajkumaar23.badgie",
            resizable: false,
            title: _("Badgie"),
            height_request: 500,
            width_request: 700,
            border_width: 10
        );
    }

    construct {
        init_type_map();
        API_URL = "https://api-playstore.rajkumaar.co.in/";
        API_REPO = "https://github.com/rajkumaar23/playstore-api";

        search_entry = new Entry();
        search_entry.set_margin_end(50);
        var search_label = new Label.with_mnemonic (_("Enter app's package name"));
        search_label.mnemonic_widget = this.search_entry;

        grid = new Grid();
        grid.row_spacing = 6;
        grid.column_spacing = 6;
        grid.column_homogeneous = true;

        grid.attach(search_label, 0, 1, 1, 1);
        grid.attach_next_to(this.search_entry, search_label, Gtk.PositionType.RIGHT, 1, 1);

        var desc = new Label("");
        desc.set_markup("""<span font="15">""" + _("Badges for your Android App's README") + "</span>");
        desc.set_margin_bottom(10);
        grid.attach_next_to(desc, search_label, Gtk.PositionType.TOP, 2, 1);

        Gtk.ListStore liststore = new Gtk.ListStore (1, typeof (string));
        foreach (var item in this.types_array) {
			 Gtk.TreeIter iter;
			 liststore.append (out iter);
			 liststore.set (iter, 0, item);
		}
		types = new Gtk.ComboBox.with_model (liststore);
		Gtk.CellRendererText cell = new Gtk.CellRendererText ();
		types.pack_start (cell, false);
    	types.set_attributes (cell, "text", 0);
    	types.set_active (0);
    	types.set_margin_end(50);

    	var type_label = new Label.with_mnemonic (_("Choose badge type"));
        type_label.mnemonic_widget = types;

    	grid.attach_next_to(type_label, search_label, Gtk.PositionType.BOTTOM, 1, 1);
    	grid.attach_next_to(types, type_label, Gtk.PositionType.RIGHT, 1, 1);

    	button = new Gtk.Button.with_label (_("Fetch the badge"));
		button.clicked.connect (this.fetch_badge);
		button.show ();
		button.set_margin_top(10);
		button.set_margin_start(50);
		button.set_margin_end(50);
		grid.attach_next_to(button, type_label, Gtk.PositionType.BOTTOM, 2, 1);

		image = new Image();
		image.set_margin_top(15);
		grid.attach_next_to(image, button, Gtk.PositionType.BOTTOM, 2, 1);

		error_view = new Label("");
		error_view.set_margin_top(15);
		error_view.single_line_mode = false;
		grid.attach_next_to(error_view, button, Gtk.PositionType.BOTTOM, 2, 1);

	    copy_source = new Gtk.Button.with_label (_("Copy badge link"));
		copy_source.clicked.connect (this.copy_markdown);
		copy_source.set_margin_top(10);
		copy_source.set_margin_start(50);
		copy_source.set_margin_end(50);
		copy_source.show();
		grid.attach_next_to(copy_source, image, Gtk.PositionType.BOTTOM, 2, 1);
        this.copy_source.sensitive = false;

        var details = new Label("");
		details.set_markup(_("For more details, visit <a href='%s'>here</a>.").printf(API_REPO));
		grid.attach_next_to(details, copy_source, Gtk.PositionType.BOTTOM, 2, 1);


        add(grid);
        show_all ();
    }

    async void fetch_badge(Gtk.Button button){
        if(search_entry.get_text() == ""){
            return;
        }
        this.button.label = _("Fetching your badge…");
        this.button.sensitive = false;
        this.copy_source.label = _("Copy badge link");
        this.copy_source.sensitive = false;
        var uri = new Soup.URI("https://img.shields.io/endpoint?color=success&url=" + API_URL
                    +this.type_map.get(types_array[types.get_active()]) + "?id=" + search_entry.get_text());

        try{
            var session = new Soup.Session();
            var req = session.request(uri.to_string(false));
            var stream = new BufferedInputStream(
                yield req.send_async(null)
            );
            Gdk.Pixbuf pixbuf = yield new Gdk.Pixbuf.from_stream_at_scale_async (stream, -1, 40, true);
            this.image.set_from_pixbuf (pixbuf);
            this.copy_source.sensitive = true;
        }catch(Error error){
            stderr.printf((string)error);
            this.error_view.set_text(_("Oops! An unexpected error occurred 😓️"));
        }finally{
            this.button.label = _("Fetch your badge");
            this.button.sensitive = true;
        }
    }

    public void copy_markdown(){
        Clipboard clipboard = Clipboard.get_default(Gdk.Display.get_default());
        clipboard.set_text("https://img.shields.io/endpoint?color=success&url=" + API_URL
                    +this.type_map.get(types_array[types.get_active()]) + "?id=" + search_entry.get_text(),-1);
        this.copy_source.label = _("Copied!");
        this.copy_source.sensitive = false;
        Timeout.add_seconds (2, () => {
            this.copy_source.label = _("Copy badge link");
            this.copy_source.sensitive = true;
            return false;
        });
    }

    public void init_type_map(){
        this.types_array = {_("Version"), _("Installs"), _("Rating"), _("Size"), _("Developer"), _("Last Updated"), _("No of users rated")};
        this.type_map = new Gee.HashMap<string, string>();
        this.type_map.set(_("Version"),"version");
        this.type_map.set(_("Installs"),"downloads");
        this.type_map.set(_("Rating"),"rating");
        this.type_map.set(_("Size"),"size");
        this.type_map.set(_("Developer"),"developer");
        this.type_map.set(_("Last Updated"),"lastUpdated");
        this.type_map.set(_("No of users rated"),"noOfUsersRated");
    }
}
