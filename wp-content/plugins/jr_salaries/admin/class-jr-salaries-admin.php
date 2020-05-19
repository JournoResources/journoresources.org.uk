<?php

/**
 * The admin-specific functionality of the plugin.
 *
 * @since      1.0.0
 *
 * @package    JR_Salaries
 * @subpackage JR_Salaries/admin
 */

/**
 * The admin-specific functionality of the plugin.
 *
 * Defines the plugin name, version, and two examples hooks for how to
 * enqueue the admin-specific stylesheet and JavaScript.
 *
 * @package    JR_Salaries
 * @subpackage JR_Salaries/admin
 * @author     Elliot Davies <elliot.a.davies@gmail.com>
 */
class JR_Salaries_Admin {

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
		$this->register_acf_fields_salaries();
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
	 * Register the custom 'Salaries' post type
	 *
	 * @since    1.0.0
	 */
	public function add_custom_post_type()
	{
		$labels = array(
			'name'                  => _x( 'Salaries', 'Post Type General Name', 'text_domain' ),
			'singular_name'         => _x( 'Salary', 'Post Type Singular Name', 'text_domain' ),
			'menu_name'             => __( 'Salaries', 'text_domain' ),
			'name_admin_bar'        => __( 'Salary', 'text_domain' ),
			'archives'              => __( 'Salary Archives', 'text_domain' ),
			'attributes'            => __( 'Salary Attributes', 'text_domain' ),
			'parent_item_colon'     => __( 'Parent Salary:', 'text_domain' ),
			'all_items'             => __( 'All Salaries', 'text_domain' ),
			'add_new_item'          => __( 'Add New Salary', 'text_domain' ),
			'add_new'               => __( 'Add New', 'text_domain' ),
			'new_item'              => __( 'New Salary', 'text_domain' ),
			'edit_item'             => __( 'Edit Salary', 'text_domain' ),
			'update_item'           => __( 'Update Salary', 'text_domain' ),
			'view_item'             => __( 'View Salary', 'text_domain' ),
			'view_items'            => __( 'View Salaries', 'text_domain' ),
			'search_items'          => __( 'Search Salary', 'text_domain' ),
			'not_found'             => __( 'Not found', 'text_domain' ),
			'not_found_in_trash'    => __( 'Not found in Trash', 'text_domain' ),
			'featured_image'        => __( 'Featured Image', 'text_domain' ),
			'set_featured_image'    => __( 'Set featured image', 'text_domain' ),
			'remove_featured_image' => __( 'Remove featured image', 'text_domain' ),
			'use_featured_image'    => __( 'Use as featured image', 'text_domain' ),
			'insert_into_item'      => __( 'Insert into Salary', 'text_domain' ),
			'uploaded_to_this_item' => __( 'Uploaded to this salary', 'text_domain' ),
			'items_list'            => __( 'Salaries list', 'text_domain' ),
			'items_list_navigation' => __( 'Salaries list navigation', 'text_domain' ),
			'filter_items_list'     => __( 'Filter salaries list', 'text_domain' ),
		);
		$rewrite = array(
			'slug'                  => 'salary',
			'with_front'            => true,
			'pages'                 => true,
			'feeds'                 => true,
		);
		$args = array(
			'label'                 => __( 'Salary', 'text_domain' ),
			'description'           => __( 'A Journo Resources salary listing', 'text_domain' ),
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
			'rest_base'             => 'salaries',
		);
		register_post_type( 'jr_salary', $args );
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
			'menu_name'             => __( 'Salary Categories', 'text_domain' ),
			'name_admin_bar'        => __( 'Category', 'text_domain' ),
			'archives'              => __( 'Category Archives', 'text_domain' ),
			'attributes'            => __( 'Category Attributes', 'text_domain' ),
			'parent_item_colon'     => __( 'Parent Category:', 'text_domain' ),
			'all_items'             => __( 'Salary Categories', 'text_domain' ),
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
			'slug'                  => 'salary-category',
			'with_front'            => true,
			'pages'                 => true,
			'feeds'                 => true,
		);

		$args = array(
			'description'           => __( 'A Journo Resources salary category', 'text_domain' ),
			'labels'                => $labels,
			'supports'              => array( 'title' ),
			'hierarchical'          => false,
			'public'                => true,
			'show_ui'               => true,
			'show_in_menu'          => 'edit.php?post_type=jr_salary',
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
			'rest_base'             => 'salary-categories',
		);
		register_taxonomy( 'jr_salarycategory', 'jr_salary', $args );
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
	 * Register salary fields with ACF
	 *
	 * @since    1.0.0
	 */
	private function register_acf_fields_salaries()
	{
		if(function_exists("register_field_group"))
		{
			register_field_group(array (
				'id' => 'acf_salaries',
				'title' => 'Salaries',
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
						'name' => 'salary_category',
						'type' => 'taxonomy',
            'taxonomy' => 'jr_salarycategory',
						'field_type' => 'select',
            'allow_term' => 0
					),

					array (
						'key' => 'field_8b5fc8d5-03be',
						'label' => 'Salary per annum',
						'name' => 'salary',
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
						'label' => 'Extra salary information',
						'name' => 'extra_salary_info',
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
							'value' => 'jr_salary',
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
	 * Register salary category fields with ACF
	 *
	 * @since    1.3.0
	 */
  private function register_acf_fields_categories()
	{
		if(function_exists("register_field_group"))
		{
			register_field_group(array (
				'id' => 'acf_salarycategory',
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
							'value' => 'jr_salarycategory',
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
      'salary' => __('Salary'),
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
			case 'salary_category' :
				echo $fields['salary_category'];
				break;
			case 'salary' :
				echo $fields['salary'];
				break;
			case 'year' :
				echo $fields['year'];
				break;
    }
	}

	/**
	 * Register custom /jr/v1/salaries REST endpoints
	 *
	 * @since    1.0.0
	 */
	public function add_custom_rest_endpoints() {
    $this->add_get_salaries_endpoint();
    $this->add_post_salary_endpoint();

    $this->add_get_categories_endpoint();
  }

	/**
	 * Register custom /jr/v1/salaries GET endpoint
	 *
	 * @since    1.0.0
	 */
	private function add_get_salaries_endpoint() {

		$jr_salaries_endpoint = function ( $request ) {

			$args = array(
				'post_type' => 'jr_salary',
				'posts_per_page' => -1,
			);

			// The basic get_posts response includes lots of extra fields from WP...
			$salariesData = get_posts( $args );

			$salaries = array();

			foreach ( $salariesData as $key => $salaryData ) {

				$salaryID = $salaryData->ID;

				// ... so we pick the ones we want
				$salary = array(
					'job_title' => $salaryData->post_title,
					// 'link' => get_permalink( $salaryID ),
					'params' => $params
				);

				$customFieldsData = get_fields( $salaryID );

				$customFieldsToInclude = array(
          'anonymise_company',
          'location',
          'salary_category',
          'salary',
          'part_time',
          'extra_salary_info',
          'year',
				);

        foreach ( $customFieldsToInclude as $cf ) {
          $fieldData = $customFieldsData[$cf];
					$salary[$cf] = $fieldData;

          if ($cf == 'anonymise_company') {
            if ($fieldData == true) {
              $salary['company_name'] = $customFieldsData['company_name_anonymised'];
            } else {
              $salary['company_name'] = $customFieldsData['company_name'];
            }
          }

          if ($cf == 'salary') {
            $salary[$cf] = intval($fieldData);
          }
				};

				$salaries[$key] = $salary;
			}

			return $salaries;
		};

		register_rest_route( 'jr/v1', '/salaries/', array(
			'methods'  => 'GET',
			'callback' => $jr_salaries_endpoint
		));
	}

	/**
	 * Register custom /jr/v1/salaries POST endpoint
	 *
	 * @since    1.0.0
	 */
	private function add_post_salary_endpoint() {

		$jr_salaries_endpoint = function ( $request ) {

      $job_title = $request->get_param( 'job_title' );

			$args = array(
        'post_type'  => 'jr_salary',
        'post_title' => $job_title,
        'meta_input' => array(
				  'name'              => $request->get_param( 'name' ),
					'email'             => $request->get_param( 'email' ),
					'company_name'      => $request->get_param( 'company_name' ),
					'anonymise_company' => $request->get_param( 'anonymise_company' ),
					'location'          => $request->get_param( 'location' ),
					'salary'            => $request->get_param( 'salary' ),
					'part_time'         => $request->get_param( 'part_time' ),
					'extra_salary_info' => $request->get_param( 'extra_salary_info' ),
					'year'              => $request->get_param( 'year' ),
        ),
      );

			wp_insert_post( $args );
		};

		register_rest_route( 'jr/v1', '/salaries/', array(
			'methods' => 'POST',
			'callback' => $jr_salaries_endpoint
		));
	}

	/**
	 * Register custom /jr/v1/salaries/categories REST endpoint
	 *
	 * @since    1.0.0
	 */
	public function add_get_categories_endpoint() {

		$jr_salary_categories_endpoint = function ( $request ) {

      $args = array(
        'taxonomy' => 'jr_salarycategory',
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

		register_rest_route( 'jr/v1', '/salaries/categories/', array(
			'methods' => 'GET',
      'callback' => $jr_salary_categories_endpoint
		));
	}

	/**
	 * Hide admin fields on salary category pages
	 *
	 * @since    1.0.0
	 */
	public function hide_salarycategory_admin_fields() {
    ?><style>.term-description-wrap,.term-slug-wrap{display:none;}</style><?php
  }
}
