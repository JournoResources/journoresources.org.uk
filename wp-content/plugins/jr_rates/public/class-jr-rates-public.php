<?php
/**
 * The public-facing functionality of the plugin.
 *
 * @since      1.0.0
 *
 * @package    JR_Rates
 * @subpackage JR_Rates/public
 */

/**
 * The public-facing functionality of the plugin.
 *
 * Defines the plugin name, version, and two examples hooks for how to
 * enqueue the public-facing stylesheet and JavaScript.
 *
 * @package    JR_Rates
 * @subpackage JR_Rates/public
 * @author     Elliot Davies <elliot.a.davies@gmail.com>
 */
class JR_Rates_Public {
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
		if (defined('WP_DEV')) {
			$path = 'http://localhost:3003/main.css';
		} else {
			$path = plugin_dir_url( __FILE__ ) . 'build/main.css';
		}

		wp_enqueue_style( $this->plugin_name, $path, array(), $this->version, 'all' );
  }
    
	/**
	 * Register the JavaScript for the public-facing side of the site.
	 *
	 * @since    1.0.0
	 */
	public function enqueue_scripts() {

		if (defined('WP_DEV')) {
			$path = 'http://localhost:3003/main.js';
		} else {
			$path = plugin_dir_url( __FILE__ ) . 'build/main.js';
		}

		wp_enqueue_script( $this->plugin_name, $path, array(), $this->version, true );

		wp_enqueue_script( "recaptcha-api", "https://www.google.com/recaptcha/api.js?onload=recaptchaOnloadCallback&render=explicit", array(), null, true );
	}
	
	/**
	 * Register shortcodes for the public-facing side of the site.
	 *
	 * @since    1.0.0
	 */
	public function register_shortcodes() {
		add_shortcode( 'jr_rates_form', array( $this, 'display_rates_form' ) );
		add_shortcode( 'jr_rates_list', array( $this, 'display_rates_list' ) );
	}

	/**
	 * Render a partial template when the plugin is included via a shortcode
	 *
	 * @since    1.0.0
	 */
	public function display_rates_form( $attrs = array() ) {
		ob_start();
		include('partials/jr-rates-form-display.php');
		$output = ob_get_contents();
		ob_end_clean();

		return $output;
	}

	/**
	 * Render a partial template when the plugin is included via a shortcode
	 *
	 * @since    1.0.0
	 */
	public function display_rates_list( $attrs = array() ) {
		ob_start();
		include('partials/jr-rates-list-display.php');
		$output = ob_get_contents();
		ob_end_clean();

		return $output;
	}
}
