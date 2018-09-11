<?php
/**
 * The file that defines the core plugin class
 *
 * A class definition that includes attributes and functions used across both the
 * public-facing side of the site and the admin area.
 *
 * @link       http://example.com
 * @since      1.0.0
 *
 * @package    JR_JobListings
 * @subpackage JR_JobListings/includes
 */

/**
 * The core plugin class.
 *
 * This is used to define internationalization, admin-specific hooks, and
 * public-facing site hooks.
 *
 * Also maintains the unique identifier of this plugin as well as the current
 * version of the plugin.
 *
 * @since      1.0.0
 * @package    JR_JobListings
 * @subpackage JR_JobListings/includes
 * @author     Your Name <email@example.com>
 */
class JR_JobListings {
	/**
	 * The loader that's responsible for maintaining and registering all hooks that power
	 * the plugin.
	 *
	 * @since    1.0.0
	 * @access   protected
	 * @var      JR_JobListings_Loader    $loader    Maintains and registers all hooks for the plugin.
	 */
    protected $loader;
    
	/**
	 * The unique identifier of this plugin.
	 *
	 * @since    1.0.0
	 * @access   protected
	 * @var      string    $plugin_name    The string used to uniquely identify this plugin.
	 */
	protected $plugin_name;
    
    /**
	 * The current version of the plugin.
	 *
	 * @since    1.0.0
	 * @access   protected
	 * @var      string    $version    The current version of the plugin.
	 */
	protected $version;
    
    /**
	 * Define the core functionality of the plugin.
	 *
	 * Set the plugin name and the plugin version that can be used throughout the plugin.
	 * Load the dependencies, define the locale, and set the hooks for the admin area and
	 * the public-facing side of the site.
	 *
	 * @since    1.0.0
	 */
	public function __construct() {

		$host = $_SERVER['SERVER_NAME'];
		switch ($host) {
			case 'localhost':
				define('WP_DEV', true);
				break;
		}
		
		if ( defined( 'JR_JOBLISTINGS_VERSION' ) ) {
			$this->version = JR_JOBLISTINGS_VERSION;
		} else {
			$this->version = '1.0.0';
		}

		$this->plugin_name = 'jr-joblistings';
		
		$this->load_dependencies();
		$this->load_vendor_dependencies();
		$this->set_locale();
		$this->define_admin_hooks();
		$this->define_public_hooks();
	}
    
  /**
	 * Load the required dependencies for this plugin.
	 *
	 * Include the following files that make up the plugin:
	 *
	 * - JR_JobListings_Loader. Orchestrates the hooks of the plugin.
	 * - JR_JobListings_i18n. Defines internationalization functionality.
	 * - JR_JobListings_Admin. Defines all hooks for the admin area.
	 * - JR_JobListings_Public. Defines all hooks for the public side of the site.
	 *
	 * Create an instance of the loader which will be used to register the hooks
	 * with WordPress.
	 *
	 * @since    1.0.0
	 * @access   private
	 */
	private function load_dependencies() {
		/**
		 * The class responsible for orchestrating the actions and filters of the
		 * core plugin.
		 */
		require_once plugin_dir_path( dirname( __FILE__ ) ) . 'includes/class-jr-joblistings-loader.php';

		/**
		 * The class responsible for defining internationalization functionality
		 * of the plugin.
		 */
		require_once plugin_dir_path( dirname( __FILE__ ) ) . 'includes/class-jr-joblistings-i18n.php';
		
		/**
		 * The class responsible for defining all actions that occur in the admin area.
		 */
		require_once plugin_dir_path( dirname( __FILE__ ) ) . 'admin/class-jr-joblistings-admin.php';
		
		/**
		 * The class responsible for defining all actions that occur in the public-facing
		 * side of the site.
		 */
		require_once plugin_dir_path( dirname( __FILE__ ) ) . 'public/class-jr-joblistings-public.php';
		
		$this->loader = new JR_JobListings_Loader();
	}
	
	/**
	 * Load vendor dependencies, such as bundled plugins
	 *
	 * @since    1.0.0
	 * @access   private
	 */
	private function load_vendor_dependencies()
	{
		/**
		 * Advanced Custom Fields
		 */
		$this->loader->add_filter( 'acf/settings/path', $plugin_admin, 'get_acf_settings_path' );
		$this->loader->add_filter( 'acf/settings/dir', $plugin_admin, 'get_acf_settings_dir' );
		define( 'ACF_LITE', false ); // Hide ACF UI
		include_once( plugin_dir_path( __FILE__ ) . '../vendor/acf/acf.php' );
	}
    
	/**
	 * Define the locale for this plugin for internationalization.
	 *
	 * Uses the JR_JobListings_i18n class in order to set the domain and to register the hook
	 * with WordPress.
	 *
	 * @since    1.0.0
	 * @access   private
	 */
	private function set_locale() {
		$plugin_i18n = new JR_JobListings_i18n();
		$this->loader->add_action( 'plugins_loaded', $plugin_i18n, 'load_plugin_textdomain' );
	}

  /**
	 * Register all of the hooks related to the admin area functionality
	 * of the plugin.
	 *
	 * @since    1.0.0
	 * @access   private
	 */
	private function define_admin_hooks() {
		$plugin_admin = new JR_JobListings_Admin( $this->get_plugin_name(), $this->get_version() );
		$this->loader->add_action( 'admin_enqueue_scripts', $plugin_admin, 'enqueue_styles' );
		$this->loader->add_action( 'admin_enqueue_scripts', $plugin_admin, 'enqueue_scripts' );

		$this->loader->add_action( 'init', $plugin_admin, 'add_custom_post_type' );
		$this->loader->add_action( 'rest_api_init', $plugin_admin, 'add_custom_rest_endpoint' );
		
		$this->loader->add_filter( 'manage_jr_joblisting_posts_columns', $plugin_admin, 'add_custom_admin_columns' );
		$this->loader->add_filter( 'manage_jr_joblisting_posts_custom_column', $plugin_admin, 'manage_custom_admin_columns', 10, 2 );
	}

  /**
	 * Register all of the hooks related to the public-facing functionality
	 * of the plugin.
	 *
	 * @since    1.0.0
	 * @access   private
	 */
	private function define_public_hooks() {
		$plugin_public = new JR_JobListings_Public( $this->get_plugin_name(), $this->get_version() );
		$this->loader->add_action( 'wp_enqueue_scripts', $plugin_public, 'enqueue_styles' );
		$this->loader->add_action( 'wp_enqueue_scripts', $plugin_public, 'enqueue_scripts' );

		$this->loader->add_action( 'init', $plugin_public, 'register_shortcodes' );
		$this->loader->add_action( 'wp_head', $plugin_public, 'add_company_logo_meta' );

		$this->loader->add_filter( 'single_template', $plugin_public, 'register_custom_post_template' );
    }
    
	/**
	 * Run the loader to execute all of the hooks with WordPress.
	 *
	 * @since    1.0.0
	 */
	public function run() {
		$this->loader->run();
	}
    
    /**
	 * The name of the plugin used to uniquely identify it within the context of
	 * WordPress and to define internationalization functionality.
	 *
	 * @since     1.0.0
	 * @return    string    The name of the plugin.
	 */
	public function get_plugin_name() {
		return $this->plugin_name;
	}
    
    /**
	 * The reference to the class that orchestrates the hooks with the plugin.
	 *
	 * @since     1.0.0
	 * @return    JR_JobListings_Loader    Orchestrates the hooks of the plugin.
	 */
	public function get_loader() {
		return $this->loader;
	}
    
    /**
	 * Retrieve the version number of the plugin.
	 *
	 * @since     1.0.0
	 * @return    string    The version number of the plugin.
	 */
	public function get_version() {
		return $this->version;
	}
}