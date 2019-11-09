<?php
/**
 * The plugin bootstrap file
 *
 * This file is read by WordPress to generate the plugin information in the plugin
 * admin area. This file also includes all of the dependencies used by the plugin,
 * registers the activation and deactivation functions, and defines a function
 * that starts the plugin.
 *
 * @link              https://github.com/JournoResources/journoresources.org.uk
 * @since             1.0.0
 * @package           JR_JobListings
 *
 * @wordpress-plugin
 * Plugin Name:       Journo Resources Job Listings
 * Plugin URI:        https://github.com/JournoResources/journoresources.org.uk
 * Description:       Job listings for the Journo Resources website jobs page
 * Version:           1.6.1
 * Author:            Elliot Davies
 * Author URI:        http://elliotdavies.co.uk
 * License:           GPL-2.0+
 * License URI:       http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain:       jr-joblistings
 * Domain Path:       /languages
 */

// If this file is called directly, abort.
if ( ! defined( 'WPINC' ) ) {
	die;
}

/**
 * Current plugin version
 */
define( 'JR_JOBLISTINGS_VERSION', '1.6.1' );

/**
 * The code that runs during plugin activation.
 * This action is documented in includes/class-jr-joblistings-activator.php
 */
function activate_jr_joblistings() {
	require_once plugin_dir_path( __FILE__ ) . 'includes/class-jr-joblistings-activator.php';
	jr_joblistings_Activator::activate();
}

/**
 * The code that runs during plugin deactivation.
 * This action is documented in includes/class-jr-joblistings-deactivator.php
 */
function deactivate_jr_joblistings() {
	require_once plugin_dir_path( __FILE__ ) . 'includes/class-jr-joblistings-deactivator.php';
	jr_joblistings_Deactivator::deactivate();
}

register_activation_hook( __FILE__, 'activate_jr_joblistings' );
register_deactivation_hook( __FILE__, 'deactivate_jr_joblistings' );

/**
 * The core plugin class that is used to define internationalization,
 * admin-specific hooks, and public-facing site hooks.
 */
require plugin_dir_path( __FILE__ ) . 'includes/class-jr-joblistings.php';

/**
 * Begins execution of the plugin.
 *
 * Since everything within the plugin is registered via hooks,
 * then kicking off the plugin from this point in the file does
 * not affect the page life cycle.
 *
 * @since    1.0.0
 */
function run_jr_joblistings() {
	$plugin = new jr_joblistings();
	$plugin->run();
}
run_jr_joblistings();
