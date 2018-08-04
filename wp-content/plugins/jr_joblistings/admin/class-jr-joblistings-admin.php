<?php

/**
 * The admin-specific functionality of the plugin.
 *
 * @link       http://example.com
 * @since      1.0.0
 *
 * @package    JR_JobListings
 * @subpackage JR_JobListings/admin
 */

/**
 * The admin-specific functionality of the plugin.
 *
 * Defines the plugin name, version, and two examples hooks for how to
 * enqueue the admin-specific stylesheet and JavaScript.
 *
 * @package    JR_JobListings
 * @subpackage JR_JobListings/admin
 * @author     Your Name <email@example.com>
 */
class JR_JobListings_Admin {

	/**
	 * The ID of this plugin.
	 *
	 * @since    1.0.0
	 * @access   private
	 * @var      string    $plugin_name    The ID of this plugin.
	 */
	private $plugin_name;

	/**
	 * The version of this plugin.
	 *
	 * @since    1.0.0
	 * @access   private
	 * @var      string    $version    The current version of this plugin.
	 */
	private $version;

	/**
	 * Initialize the class and set its properties.
	 *
	 * @since    1.0.0
	 * @param      string    $plugin_name       The name of this plugin.
	 * @param      string    $version    The version of this plugin.
	 */
	public function __construct( $plugin_name, $version ) {

		$this->plugin_name = $plugin_name;
		$this->version = $version;

	}

	/**
	 * Register the stylesheets for the admin area.
	 *
	 * @since    1.0.0
	 */
	public function enqueue_styles() {

		/**
		 * This function is provided for demonstration purposes only.
		 *
		 * An instance of this class should be passed to the run() function
		 * defined in JR_JobListings_Loader as all of the hooks are defined
		 * in that particular class.
		 *
		 * The JR_JobListings_Loader will then create the relationship
		 * between the defined hooks and the functions defined in this
		 * class.
		 */

		wp_enqueue_style( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'css/jr-joblistings-admin.css', array(), $this->version, 'all' );

	}

	/**
	 * Register the JavaScript for the admin area.
	 *
	 * @since    1.0.0
	 */
	public function enqueue_scripts() {

		/**
		 * This function is provided for demonstration purposes only.
		 *
		 * An instance of this class should be passed to the run() function
		 * defined in JR_JobListings_Loader as all of the hooks are defined
		 * in that particular class.
		 *
		 * The JR_JobListings_Loader will then create the relationship
		 * between the defined hooks and the functions defined in this
		 * class.
		 */

		// wp_enqueue_script( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'js/jr-joblistings-admin.js', array( 'jquery' ), $this->version, false );

	}

	public function add_custom_post_type()
	{
		$labels = array(
			'name'                  => _x( 'Jobs', 'Post Type General Name', 'text_domain' ),
			'singular_name'         => _x( 'Job', 'Post Type Singular Name', 'text_domain' ),
			'menu_name'             => __( 'Jobs', 'text_domain' ),
			'name_admin_bar'        => __( 'Job', 'text_domain' ),
			'archives'              => __( 'Job Archives', 'text_domain' ),
			'attributes'            => __( 'Job Attributes', 'text_domain' ),
			'parent_item_colon'     => __( 'Parent Job:', 'text_domain' ),
			'all_items'             => __( 'All Jobs', 'text_domain' ),
			'add_new_item'          => __( 'Add New Job', 'text_domain' ),
			'add_new'               => __( 'Add New', 'text_domain' ),
			'new_item'              => __( 'New Job', 'text_domain' ),
			'edit_item'             => __( 'Edit Job', 'text_domain' ),
			'update_item'           => __( 'Update Job', 'text_domain' ),
			'view_item'             => __( 'View Job', 'text_domain' ),
			'view_items'            => __( 'View Jobs', 'text_domain' ),
			'search_items'          => __( 'Search Job', 'text_domain' ),
			'not_found'             => __( 'Not found', 'text_domain' ),
			'not_found_in_trash'    => __( 'Not found in Trash', 'text_domain' ),
			'featured_image'        => __( 'Featured Image', 'text_domain' ),
			'set_featured_image'    => __( 'Set featured image', 'text_domain' ),
			'remove_featured_image' => __( 'Remove featured image', 'text_domain' ),
			'use_featured_image'    => __( 'Use as featured image', 'text_domain' ),
			'insert_into_item'      => __( 'Insert into Job', 'text_domain' ),
			'uploaded_to_this_item' => __( 'Uploaded to this job', 'text_domain' ),
			'items_list'            => __( 'Jobs list', 'text_domain' ),
			'items_list_navigation' => __( 'Jobs list navigation', 'text_domain' ),
			'filter_items_list'     => __( 'Filter jobs list', 'text_domain' ),
		);
		$rewrite = array(
			'slug'                  => 'job',
			'with_front'            => true,
			'pages'                 => true,
			'feeds'                 => true,
		);
		$args = array(
			'label'                 => __( 'Job', 'text_domain' ),
			'description'           => __( 'A Journo Resources job listing', 'text_domain' ),
			'labels'                => $labels,
			'supports'              => array( 'title' ),
			'hierarchical'          => false,
			'public'                => true,
			'show_ui'               => true,
			'show_in_menu'          => true,
			'menu_position'         => 5,
			'menu_icon'             => 'dashicons-carrot',
			'show_in_admin_bar'     => true,
			'show_in_nav_menus'     => true,
			'can_export'            => true,
			'has_archive'           => true,
			'exclude_from_search'   => false,
			'publicly_queryable'    => true,
			'rewrite'               => $rewrite,
			'capability_type'       => 'post',
			'show_in_rest'          => true,
			'rest_base'             => 'job',
		);
		register_post_type( 'jr_joblisting', $args );
	}

}