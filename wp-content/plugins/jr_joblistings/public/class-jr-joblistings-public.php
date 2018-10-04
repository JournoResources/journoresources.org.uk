<?php
/**
 * The public-facing functionality of the plugin.
 *
 * @since      1.0.0
 *
 * @package    JR_JobListings
 * @subpackage JR_JobListings/public
 */

/**
 * The public-facing functionality of the plugin.
 *
 * Defines the plugin name, version, and two examples hooks for how to
 * enqueue the public-facing stylesheet and JavaScript.
 *
 * @package    JR_JobListings
 * @subpackage JR_JobListings/public
 * @author     Elliot Davies <elliot.a.davies@gmail.com>
 */
class JR_JobListings_Public {
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
	 * @param      string    $plugin_name       The name of the plugin.
	 * @param      string    $version    The version of this plugin.
	 */
	public function __construct( $plugin_name, $version ) {
		$this->plugin_name = $plugin_name;
		$this->version = $version;
    }
    
	/**
	 * Register the stylesheets for the public-facing side of the site.
	 *
	 * @since    1.0.0
	 */
	public function enqueue_styles() {
		wp_enqueue_style( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'build/static/css/main.css', array(), $this->version, 'all' );
  }
    
	/**
	 * Register the JavaScript for the public-facing side of the site.
	 *
	 * @since    1.0.0
	 */
	public function enqueue_scripts() {

		if (defined('WP_DEV')) {
			$path = 'http://localhost:3001/static/js/bundle.js';
		} else {
			$path = plugin_dir_url( __FILE__ ) . 'build/static/js/main.js';
		}

		wp_enqueue_script( $this->plugin_name, $path, array(), $this->version, true );
	}
	
	/**
	 * Register shortcodes for the public-facing side of the site.
	 *
	 * @since    1.0.0
	 */
	public function register_shortcodes() {
		add_shortcode( 'jr_joblistings', array( $this, 'display_joblistings' ) );
	}

	/**
	 * Render the partial template when the plugin is included via a shortcode
	 *
	 * @since    1.0.0
	 */
	public function display_joblistings( $attrs = array() ) {
		ob_start();
		include('partials/jr-joblistings-public-display.php');
		$output = ob_get_contents();
		ob_end_clean();

		return $output;
	}

	/**
	 * Register a custom template for single job listing pages
	 *
	 * @since    1.0.0
	 */
	public function register_custom_post_template( $single_template ) {
		global $post;

		if ( $post->post_type === 'jr_joblisting' ) {
			$single_template = dirname( __FILE__ ) . '/partials/default-jr_joblistings-single.php';
		}

		return $single_template;
	}

	/**
	 * Add a meta tag to display the company logo for single job listing pages
	 *
	 * @since    1.0.1
	 */
	public function add_company_logo_meta() {
		global $post;

		if ( $post->post_type === 'jr_joblisting' ) {
			$logo = get_field('company_logo', $post->ID);
			echo '<meta property="og:image" content="' . $logo . '" />';
		}
	}
}
