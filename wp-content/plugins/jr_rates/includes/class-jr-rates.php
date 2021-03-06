<?php
/**
 * The file that defines the core plugin class
 *
 * A class definition that includes attributes and functions used across both the
 * public-facing side of the site and the admin area.
 *
 * @since      1.0.0
 *
 * @package    JR_Rates
 * @subpackage JR_Rates/includes
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
 * @package    JR_Rates
 * @subpackage JR_Rates/includes
 * @author     Elliot Davies <elliot.a.davies@gmail.com>
 */
class JR_Rates {
	/**
	 * The loader that's responsible for maintaining and registering all hooks that power
	 * the plugin.
	 *
	 * @since    1.0.0
	 * @access   protected
	 * @var      JR_Rates_Loader    $loader    Maintains and registers all hooks for the plugin.
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
	 * Load the dependencies and set the hooks for the admin area and
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
		
		if ( defined( 'JR_RATES_VERSION' ) ) {
			$this->version = JR_RATES_VERSION;
		} else {
			$this->version = '1.0.0';
		}

		$this->plugin_name = 'jr-rates';
		
		$this->load_dependencies();
		$this->load_vendor_dependencies();
		$this->define_admin_hooks();
		$this->define_public_hooks();
	}
    
  /**
	 * Load the required dependencies for this plugin.
	 *
	 * Include the following files that make up the plugin:
	 *
	 * - JR_Rates_Loader. Orchestrates the hooks of the plugin.
	 * - JR_Rates_Admin. Defines all hooks for the admin area.
	 * - JR_Rates_Public. Defines all hooks for the public side of the site.
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
		require_once plugin_dir_path( dirname( __FILE__ ) ) . 'includes/class-jr-rates-loader.php';

		/**
		 * The class responsible for defining all actions that occur in the admin area.
		 */
		require_once plugin_dir_path( dirname( __FILE__ ) ) . 'admin/class-jr-rates-admin.php';
		
		/**
		 * The class responsible for defining all actions that occur in the public-facing
		 * side of the site.
		 */
		require_once plugin_dir_path( dirname( __FILE__ ) ) . 'public/class-jr-rates-public.php';
		
		$this->loader = new JR_Rates_Loader();
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

    /**
     * Google Recaptcha API
     */
    include_once( plugin_dir_path( __FILE__ ) . '../vendor/recaptcha-1.2.4/src/autoload.php' );
	}
    
  /**
	 * Register all of the hooks related to the admin area functionality
	 * of the plugin.
	 *
	 * @since    1.0.0
	 * @access   private
	 */
	private function define_admin_hooks() {
		$plugin_admin = new JR_Rates_Admin( $this->get_plugin_name(), $this->get_version() );
		$this->loader->add_action( 'admin_enqueue_scripts', $plugin_admin, 'enqueue_styles' );
		$this->loader->add_action( 'admin_enqueue_scripts', $plugin_admin, 'enqueue_scripts' );

		$this->loader->add_action( 'init', $plugin_admin, 'add_custom_post_type' );
		$this->loader->add_action( 'init', $plugin_admin, 'add_custom_taxonomy' );
		$this->loader->add_action( 'rest_api_init', $plugin_admin, 'add_custom_rest_endpoints' );
		$this->loader->add_action( 'jr_ratecategory_edit_form', $plugin_admin, 'hide_ratecategory_admin_fields' );
		$this->loader->add_action( 'jr_ratecategory_add_form', $plugin_admin, 'hide_ratecategory_admin_fields' );
		
		$this->loader->add_filter( 'manage_jr_ratecolumns', $plugin_admin, 'add_custom_admin_columns' );
		$this->loader->add_filter( 'manage_jr_ratecustom_column', $plugin_admin, 'manage_custom_admin_columns', 10, 2 );
	}

  /**
	 * Register all of the hooks related to the public-facing functionality
	 * of the plugin.
	 *
	 * @since    1.0.0
	 * @access   private
	 */
	private function define_public_hooks() {
		$plugin_public = new JR_Rates_Public( $this->get_plugin_name(), $this->get_version() );
		$this->loader->add_action( 'wp_enqueue_scripts', $plugin_public, 'enqueue_styles' );
		$this->loader->add_action( 'wp_enqueue_scripts', $plugin_public, 'enqueue_scripts' );

		$this->loader->add_action( 'init', $plugin_public, 'register_shortcodes' );
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
	 * @return    JR_Rates_Loader    Orchestrates the hooks of the plugin.
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
