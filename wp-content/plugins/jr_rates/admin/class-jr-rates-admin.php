<?php

/**
 * The admin-specific functionality of the plugin.
 *
 * @since      1.0.0
 *
 * @package    JR_Rates
 * @subpackage JR_Rates/admin
 */

/**
 * The admin-specific functionality of the plugin.
 *
 * Defines the plugin name, version, and two examples hooks for how to
 * enqueue the admin-specific stylesheet and JavaScript.
 *
 * @package    JR_Rates
 * @subpackage JR_Rates/admin
 * @author     Elliot Davies <elliot.a.davies@gmail.com>
 */
class JR_Rates_Admin {

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
		$this->register_acf_fields_rates();
		$this->register_acf_fields_categories();

	}

	/**
	 * Register the stylesheets for the admin area.
	 *
	 * @since    1.0.0
	 */
	public function enqueue_styles() {
	}

	/**
	 * Register the JavaScript for the admin area.
	 *
	 * @since    1.0.0
	 */
	public function enqueue_scripts() {
	}

	/**
	 * Register the custom 'Rates' post type
	 *
	 * @since    1.0.0
	 */
	public function add_custom_post_type()
	{
		$labels = array(
			'name'                  => _x( 'Rates', 'Post Type General Name', 'text_domain' ),
			'singular_name'         => _x( 'Rate', 'Post Type Singular Name', 'text_domain' ),
			'menu_name'             => __( 'Rates', 'text_domain' ),
			'name_admin_bar'        => __( 'Rate', 'text_domain' ),
			'archives'              => __( 'Rate Archives', 'text_domain' ),
			'attributes'            => __( 'Rate Attributes', 'text_domain' ),
			'parent_item_colon'     => __( 'Parent Rate:', 'text_domain' ),
			'all_items'             => __( 'All Rates', 'text_domain' ),
			'add_new_item'          => __( 'Add New Rate', 'text_domain' ),
			'add_new'               => __( 'Add New', 'text_domain' ),
			'new_item'              => __( 'New Rate', 'text_domain' ),
			'edit_item'             => __( 'Edit Rate', 'text_domain' ),
			'update_item'           => __( 'Update Rate', 'text_domain' ),
			'view_item'             => __( 'View Rate', 'text_domain' ),
			'view_items'            => __( 'View Rates', 'text_domain' ),
			'search_items'          => __( 'Search Rate', 'text_domain' ),
			'not_found'             => __( 'Not found', 'text_domain' ),
			'not_found_in_trash'    => __( 'Not found in Trash', 'text_domain' ),
			'featured_image'        => __( 'Featured Image', 'text_domain' ),
			'set_featured_image'    => __( 'Set featured image', 'text_domain' ),
			'remove_featured_image' => __( 'Remove featured image', 'text_domain' ),
			'use_featured_image'    => __( 'Use as featured image', 'text_domain' ),
			'insert_into_item'      => __( 'Insert into Rate', 'text_domain' ),
			'uploaded_to_this_item' => __( 'Uploaded to this rate', 'text_domain' ),
			'items_list'            => __( 'Rates list', 'text_domain' ),
			'items_list_navigation' => __( 'Rates list navigation', 'text_domain' ),
			'filter_items_list'     => __( 'Filter rates list', 'text_domain' ),
		);
		$rewrite = array(
			'slug'                  => 'rate',
			'with_front'            => true,
			'pages'                 => true,
			'feeds'                 => true,
		);
		$args = array(
			'label'                 => __( 'Rate', 'text_domain' ),
			'description'           => __( 'A Journo Resources rate listing', 'text_domain' ),
			'labels'                => $labels,
			'supports'              => array( 'title' ),
			'hierarchical'          => false,
			'public'                => true,
			'show_ui'               => true,
			'show_in_menu'          => true,
			'menu_position'         => 5,
			'menu_icon'             => 'dashicons-cart',
			'show_in_admin_bar'     => true,
			'show_in_nav_menus'     => true,
			'can_export'            => true,
			'has_archive'           => true,
			'exclude_from_search'   => false,
			'publicly_queryable'    => true,
			'rewrite'               => $rewrite,
			'capability_type'       => 'post',
			'show_in_rest'          => true,
			'rest_base'             => 'rates',
		);
		register_post_type( 'jr_rate', $args );
	}

	/**
	 * Register the custom 'Category' taxonomy
	 *
	 * @since    1.0.0
	 */
	public function add_custom_taxonomy()
	{
		$labels = array(
			'name'                  => _x( 'Category', 'Taxonomy General Name', 'text_domain' ),
			'singular_name'         => _x( 'Category', 'Taxonomy Singular Name', 'text_domain' ),
			'menu_name'             => __( 'Rate Categories', 'text_domain' ),
			'name_admin_bar'        => __( 'Category', 'text_domain' ),
			'archives'              => __( 'Category Archives', 'text_domain' ),
			'attributes'            => __( 'Category Attributes', 'text_domain' ),
			'parent_item_colon'     => __( 'Parent Category:', 'text_domain' ),
			'all_items'             => __( 'Rate Categories', 'text_domain' ),
			'add_new_item'          => __( 'Add New Category', 'text_domain' ),
			'add_new'               => __( 'Add New', 'text_domain' ),
			'new_item'              => __( 'New Category', 'text_domain' ),
			'edit_item'             => __( 'Edit Category', 'text_domain' ),
			'update_item'           => __( 'Update Category', 'text_domain' ),
			'view_item'             => __( 'View Category', 'text_domain' ),
			'view_items'            => __( 'View Categories', 'text_domain' ),
			'search_items'          => __( 'Search Categories', 'text_domain' ),
			'not_found'             => __( 'Not found', 'text_domain' ),
			'not_found_in_trash'    => __( 'Not found in Trash', 'text_domain' ),
			'featured_image'        => __( 'Featured Image', 'text_domain' ),
			'set_featured_image'    => __( 'Set featured image', 'text_domain' ),
			'remove_featured_image' => __( 'Remove featured image', 'text_domain' ),
			'use_featured_image'    => __( 'Use as featured image', 'text_domain' ),
			'insert_into_item'      => __( 'Insert into Category', 'text_domain' ),
			'uploaded_to_this_item' => __( 'Uploaded to this category', 'text_domain' ),
			'items_list'            => __( 'Categories list', 'text_domain' ),
			'items_list_navigation' => __( 'Categories list navigation', 'text_domain' ),
			'filter_items_list'     => __( 'Filter categories list', 'text_domain' ),
      'back_to_items'         => __( 'Back to categories', 'text_domain' ),
		);
		$rewrite = array(
			'slug'                  => 'rate-category',
			'with_front'            => true,
			'pages'                 => true,
			'feeds'                 => true,
		);

		$args = array(
			'description'           => __( 'A Journo Resources rate category', 'text_domain' ),
			'labels'                => $labels,
			'supports'              => array( 'title' ),
			'hierarchical'          => false,
			'public'                => true,
			'show_ui'               => true,
			'show_in_menu'          => 'edit.php?post_type=jr_rate',
			'menu_position'         => 5,
			'menu_icon'             => 'dashicons-carrot',
			'show_in_admin_bar'     => true,
			'show_in_nav_menus'     => true,
			'can_export'            => true,
			'has_archive'           => true,
			'exclude_from_search'   => true,
			'publicly_queryable'    => false,
			'rewrite'               => $rewrite,
			'capability_type'       => 'post',
			'show_in_rest'          => true,
			'rest_base'             => 'rate-categories',
		);
		register_taxonomy( 'jr_ratecategory', 'jr_rate', $args );
	}


	/**
	 * Configure the ACF settings path in order to bundle it
	 *
	 * @since    1.0.0
	 */
	public function get_acf_settings_path( $path )
	{
		$path = plugin_dir_path( __FILE__ ) . '../vendor/acf/';
		return $path;
	}
	
	/**
	 * Configure the ACF settings directory in order to bundle it
	 *
	 * @since    1.0.0
	 */
	public function get_acf_settings_dir( $dir )
	{
		$dir = plugin_dir_path( __FILE__ ) . '../vendor/acf/';
		return $dir;
	}

	/**
	 * Register rate fields with ACF
	 *
	 * @since    1.0.0
	 */
	private function register_acf_fields_rates()
	{
		if(function_exists("register_field_group"))
		{
			register_field_group(array (
				'id' => 'acf_rates',
				'title' => 'Rates',
				'fields' => array (
					array (
						'key' => 'field_f1fb5c4b-e471',
						'label' => 'Contact name',
						'name' => 'name',
						'type' => 'text',
						'required' => 1,
						'default_value' => '',
						'placeholder' => '',
						'prepend' => '',
						'append' => '',
						'formatting' => 'html',
						'maxlength' => '',
					),

					array (
						'key' => 'field_1192881b-2b92',
						'label' => 'Contact email',
						'name' => 'email',
						'type' => 'text',
						'required' => 1,
						'default_value' => '',
						'placeholder' => '',
						'prepend' => '',
						'append' => '',
						'formatting' => 'html',
						'maxlength' => '',
					),

					array (
						'key' => 'field_236a1c13f7f2',
						'label' => 'Company name',
						'name' => 'company_name',
						'type' => 'text',
						'required' => 1,
						'default_value' => '',
						'placeholder' => '',
						'prepend' => '',
						'append' => '',
						'formatting' => 'html',
						'maxlength' => '',
					),

					array (
						'key' => 'field_935b2f78-4d0g',
						'label' => 'Anonymise company?',
						'name' => 'anonymise_company',
						'type' => 'true_false',
						'message' => '',
						'default_value' => 0,
					),

					array (
						'key' => 'field_935b2f78-4d0h',
						'label' => 'Anonymised company name',
						'name' => 'company_name_anonymised',
						'type' => 'text',
						'instructions' => '',
						'required' => 1,
						'conditional_logic' => array (
							'status' => 1,
							'rules' => array (
								array (
									'field' => 'field_935b2f78-4d0g',
									'operator' => '==',
									'value' => '1',
								),
							),
							'allorany' => 'all',
						),
						'default_value' => '',
					),

					array (
						'key' => 'field_8b5fc9d5-03be',
						'label' => 'Location',
						'name' => 'location',
						'type' => 'radio',
						'required' => 1,
            'choices' => array (
              'London' => 'London',
              'City' => 'City',
              'Rural' => 'Rural',
            ),
            'other_choice' => 0
					),

					array (
						'key' => 'field_8crfc9d5-03be',
						'label' => 'Category',
						'name' => 'rate_category',
						'type' => 'taxonomy',
            'taxonomy' => 'jr_ratecategory',
						'field_type' => 'select',
            'allow_term' => 0,
					),

					array (
						'key' => 'field_8b5fc8d5-03be',
						'label' => 'Rate per annum',
						'name' => 'rate',
						'type' => 'number',
            'min' => 0,
						'required' => 1,
          ),

					array (
						'key' => 'field_935b2f78-3d0g',
						'label' => 'Part time?',
						'name' => 'part_time',
						'type' => 'true_false',
						'message' => '',
						'default_value' => 0,
					),

					array (
						'key' => 'field_935b3f78-4d0h',
						'label' => 'Extra rate information',
						'name' => 'extra_rate_info',
						'type' => 'text',
						'instructions' => '',
						'required' => 1,
						'conditional_logic' => array (
							'status' => 1,
							'rules' => array (
								array (
									'field' => 'field_935b2f78-3d0g',
									'operator' => '==',
									'value' => '1',
								),
							),
							'allorany' => 'all',
						),
						'default_value' => '',
					),

					array (
						'key' => 'field_5b75c9d38f5bb',
						'label' => 'Year',
						'name' => 'year',
						'type' => 'text',
						'required' => 1,
					),
				),

				'location' => array (
					array (
						array (
							'param' => 'post_type',
							'operator' => '==',
							'value' => 'jr_rate',
							'order_no' => 0,
							'group_no' => 0,
						),
					),
				),

				'options' => array (
					'position' => 'normal',
					'layout' => 'no_box',
					'hide_on_screen' => array (
						0 => 'permalink',
						1 => 'the_content',
						2 => 'excerpt',
						3 => 'custom_fields',
						4 => 'discussion',
						5 => 'comments',
						6 => 'revisions',
						7 => 'format',
						8 => 'featured_image',
						9 => 'categories',
						10 => 'tags',
						11 => 'send-trackbacks',
					),
				),
				'menu_order' => 0,
			));
		}
	}

	/**
	 * Register rate category fields with ACF
	 *
	 * @since    1.3.0
	 */
  private function register_acf_fields_categories()
	{
		if(function_exists("register_field_group"))
		{
			register_field_group(array (
				'id' => 'acf_ratecategory',
				'title' => 'Category',
				'fields' => array (
					array (
						'key' => 'field_6d85c99d8f5b8',
						'label' => 'Recommendation (London)',
						'name' => 'recommended_london',
						'type' => 'number',
						'required' => 1,
						'default_value' => '',
						'prepend' => '',
						'append' => '',
						'maxlength' => '',
					),
					array (
						'key' => 'field_6d85c99d8f5b9',
						'label' => 'Recommendation (outside London - rural)',
						'name' => 'recommended_rural',
						'type' => 'number',
						'required' => 1,
						'default_value' => '',
						'prepend' => '',
						'append' => '',
						'maxlength' => '',
					),
					array (
						'key' => 'field_6d85c99d8f5b7',
						'label' => 'Recommendation (outside London - city)',
						'name' => 'recommended_city',
						'type' => 'number',
						'required' => 1,
						'default_value' => '',
						'prepend' => '',
						'append' => '',
						'maxlength' => '',
					),
				),

				'location' => array (
					array (
						array (
							'param' => 'ef_taxonomy',
							'operator' => '==',
							'value' => 'jr_ratecategory',
							'order_no' => 0,
							'group_no' => 0,
						),
					),
				),

				'options' => array (
					'position' => 'normal',
					'layout' => 'no_box',
					'hide_on_screen' => array (
						0 => 'permalink',
						1 => 'the_content',
						2 => 'excerpt',
						3 => 'custom_fields',
						4 => 'discussion',
						5 => 'comments',
						6 => 'revisions',
						7 => 'format',
						8 => 'featured_image',
						9 => 'categories',
						10 => 'tags',
						11 => 'send-trackbacks',
					),
				),
				'menu_order' => 0,
			));
		}
	}

	/**
	 * Register custom columns for admin screen
	 *
	 * @since    1.0.0
	 */
	public function add_custom_admin_columns( $columns ) {
		return array(
			'cb' => $columns['cb'],
			'title' => $columns['title'],
      'company_name' => __('Company'),
      'location' => __('Location'),
      'rate' => __('Rate'),
      'year' => __('Year'),
		);

	}

	/**
	 * Manage content of custom columns on admin screen
	 *
	 * @since    1.0.0
	 */
	public function manage_custom_admin_columns( $column, $post_id ) {
		$fields = get_fields( $post_id );

    switch ( $column ) {
			case 'company_name' :
				echo $fields['company_name'];
				break;
			case 'location' :
				echo $fields['location'];
				break;
			case 'rate_category' :
				echo $fields['rate_category'];
				break;
			case 'rate' :
				echo $fields['rate'];
				break;
			case 'year' :
				echo $fields['year'];
				break;
    }
	}

	/**
	 * Register custom /jr/v1/rates REST endpoints
	 *
	 * @since    1.0.0
	 */
	public function add_custom_rest_endpoints() {
    $this->add_get_rates_endpoint();
    $this->add_post_rate_endpoint();

    $this->add_get_categories_endpoint();
  }

	/**
	 * Register custom /jr/v1/rates GET endpoint
	 *
	 * @since    1.0.0
	 */
	private function add_get_rates_endpoint() {

		$jr_rates_endpoint = function ( $request ) {

			$args = array(
				'post_type' => 'jr_rate',
				'posts_per_page' => -1,
			);

			// The basic get_posts response includes lots of extra fields from WP...
			$ratesData = get_posts( $args );

			$rates = array();

			foreach ( $ratesData as $key => $rateData ) {

				$rateID = $rateData->ID;

				// ... so we pick the ones we want
				$rate = array(
					'job_title' => $rateData->post_title,
					// 'link' => get_permalink( $rateID ),
					'params' => $params
				);

				$customFieldsData = get_fields( $rateID );

				$customFieldsToInclude = array(
          'anonymise_company',
          'location',
          'rate_category',
          'rate',
          'part_time',
          'extra_rate_info',
          'year',
				);

        foreach ( $customFieldsToInclude as $cf ) {
          $fieldData = $customFieldsData[$cf];
					$rate[$cf] = $fieldData;

          if ($cf == 'anonymise_company') {
            if ($fieldData == true) {
              $rate['company_name'] = $customFieldsData['company_name_anonymised'];
            } else {
              $rate['company_name'] = $customFieldsData['company_name'];
            }
          }

          if ($cf == 'rate') {
            $rate[$cf] = intval($fieldData);
          }
				};

				$rates[$key] = $rate;
			}

			return $rates;
		};

		register_rest_route( 'jr/v1', '/rates/', array(
			'methods'  => 'GET',
			'callback' => $jr_rates_endpoint
		));
	}

	/**
	 * Register custom /jr/v1/rates POST endpoint
	 *
	 * @since    1.0.0
	 */
	private function add_post_rate_endpoint() {

		$jr_rates_endpoint = function ( $request ) {

      $job_title = $request->get_param( 'job_title' );

			$args = array(
        'post_type'  => 'jr_rate',
        'post_title' => $job_title,
        'meta_input' => array(
				  'name'              => $request->get_param( 'name' ),
					'email'             => $request->get_param( 'email' ),
					'company_name'      => $request->get_param( 'company_name' ),
					'anonymise_company' => $request->get_param( 'anonymise_company' ),
					'location'          => $request->get_param( 'location' ),
					'rate'            => $request->get_param( 'rate' ),
					'part_time'         => $request->get_param( 'part_time' ),
					'extra_rate_info' => $request->get_param( 'extra_rate_info' ),
					'year'              => $request->get_param( 'year' ),
        ),
      );

      $gRecaptchaResponse = $request->get_param( 'g-recaptcha-response' );
      $secretFile = plugin_dir_path( __FILE__ ) . '../recaptcha-secret.env';
      $secret = file_get_contents( $secretFile );

      $recaptcha = new \ReCaptcha\ReCaptcha( $secret );
      $resp = $recaptcha->verify( $gRecaptchaResponse );

      if ($resp->isSuccess()) {
        wp_insert_post( $args );
      } else {
        /* $errors = $resp->getErrorCodes(); */
      }
		};

		register_rest_route( 'jr/v1', '/rates/', array(
			'methods' => 'POST',
			'callback' => $jr_rates_endpoint
		));
	}

	/**
	 * Register custom /jr/v1/rates/categories REST endpoint
	 *
	 * @since    1.0.0
	 */
	public function add_get_categories_endpoint() {

		$jr_rate_categories_endpoint = function ( $request ) {

      $args = array(
        'taxonomy' => 'jr_ratecategory',
        'hide_empty' => false
      );

      $categoriesData = get_terms( $args );

      $categories = array();

      foreach ( $categoriesData as $key => $categoryData ) {

        $taxonomyWithId = $categoryData->taxonomy . '_' . $categoryData->term_id;
        $customFieldsData = get_fields($taxonomyWithId);

        $category = array(
          'id' => $categoryData->term_id,
          'text' => $categoryData->name,
        );

        $customFieldsToInclude = array(
          'recommended_london',
          'recommended_rural',
          'recommended_city',
        );

        foreach ( $customFieldsToInclude as $cf ) {
          $fieldData = $customFieldsData[$cf];
          $category[$cf] = $fieldData;
        };

        $categories[$key] = $category;
      }

      return $categories;
    };

		register_rest_route( 'jr/v1', '/rates/categories/', array(
			'methods' => 'GET',
      'callback' => $jr_rate_categories_endpoint
		));
	}

	/**
	 * Hide admin fields on rate category pages
	 *
	 * @since    1.0.0
	 */
	public function hide_ratecategory_admin_fields() {
    ?><style>.term-description-wrap,.term-slug-wrap{display:none;}</style><?php
  }
}
