<?php

/**
 * The admin-specific functionality of the plugin.
 *
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
 * @author     Elliot Davies <elliot.a.davies@gmail.com>
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
		$this->register_acf_fields_joblistings();
		$this->register_acf_fields_joblabels();

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
	 * Register the custom 'Jobs' post type
	 *
	 * @since    1.0.0
	 */
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
			'rest_base'             => 'jobs',
		);
		register_post_type( 'jr_joblisting', $args );
	}

	/**
	 * Register the custom 'Labels' taxonomy
	 *
	 * @since    1.3.0
	 */
	public function add_custom_taxonomy()
	{
		$labels = array(
			'name'                  => _x( 'Labels', 'Taxonomy General Name', 'text_domain' ),
			'singular_name'         => _x( 'Label', 'Taxonomy Singular Name', 'text_domain' ),
			'menu_name'             => __( 'Labels', 'text_domain' ),
			'name_admin_bar'        => __( 'Label', 'text_domain' ),
			'archives'              => __( 'Label Archives', 'text_domain' ),
			'attributes'            => __( 'Label Attributes', 'text_domain' ),
			'parent_item_colon'     => __( 'Parent Label:', 'text_domain' ),
			'all_items'             => __( 'Job Labels', 'text_domain' ),
			'add_new_item'          => __( 'Add New Label', 'text_domain' ),
			'add_new'               => __( 'Add New', 'text_domain' ),
			'new_item'              => __( 'New Label', 'text_domain' ),
			'edit_item'             => __( 'Edit Label', 'text_domain' ),
			'update_item'           => __( 'Update Label', 'text_domain' ),
			'view_item'             => __( 'View Label', 'text_domain' ),
			'view_items'            => __( 'View Labels', 'text_domain' ),
			'search_items'          => __( 'Search Label', 'text_domain' ),
			'not_found'             => __( 'Not found', 'text_domain' ),
			'not_found_in_trash'    => __( 'Not found in Trash', 'text_domain' ),
			'featured_image'        => __( 'Featured Image', 'text_domain' ),
			'set_featured_image'    => __( 'Set featured image', 'text_domain' ),
			'remove_featured_image' => __( 'Remove featured image', 'text_domain' ),
			'use_featured_image'    => __( 'Use as featured image', 'text_domain' ),
			'insert_into_item'      => __( 'Insert into Label', 'text_domain' ),
			'uploaded_to_this_item' => __( 'Uploaded to this label', 'text_domain' ),
			'items_list'            => __( 'Labels list', 'text_domain' ),
			'items_list_navigation' => __( 'Labels list navigation', 'text_domain' ),
			'filter_items_list'     => __( 'Filter labels list', 'text_domain' ),
		);
		$rewrite = array(
			'slug'                  => 'job-label',
			'with_front'            => true,
			'pages'                 => true,
			'feeds'                 => true,
		);
		$args = array(
			'description'           => __( 'A Journo Resources job label', 'text_domain' ),
			'labels'                => $labels,
			'supports'              => array( 'title' ),
			'hierarchical'          => false,
			'public'                => true,
			'show_ui'               => true,
			'show_in_menu'          => 'edit.php?post_type=jr_joblisting',
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
			'rest_base'             => 'labels',
		);
		register_taxonomy( 'jr_joblabel', 'jr_joblisting', $args );
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
	 * Register job listing fields with ACF
	 *
	 * @since    1.0.0
	 */
	private function register_acf_fields_joblistings()
	{
		if(function_exists("register_field_group"))
		{
			register_field_group(array (
				'id' => 'acf_jobs',
				'title' => 'Jobs',
				'fields' => array (
					array (
						'key' => 'field_5b65c99d8f5b8',
						'label' => 'Employer',
						'name' => 'employer',
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
						'key' => 'field_5b65c9ac8f5b9',
						'label' => 'Location',
						'name' => 'location',
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
						'key' => 'field_5b65c9bf8f5ba',
						'label' => 'Salary',
						'name' => 'salary',
						'type' => 'text',
						'required' => 1,
						'default_value' => '',
						'placeholder' => '',
						'prepend' => '',
						'append' => '',
						'formatting' => 'html',
						'maxlength' => '',
          ),

          array(
            'key' => 'field_5b65c9d38f5cb',
						'label' => 'Citation',
						'name' => 'citation',
						'type' => 'text',
						'required' => 0,
						'default_value' => '',
						'placeholder' => '',
						'prepend' => '',
						'append' => '',
						'formatting' => 'html',
						'maxlength' => '',
          ),

          array(
            'key' => 'field_5b65c9d38f5cc',
						'label' => 'Citation URL',
						'name' => 'citation_url',
						'type' => 'text',
						'required' => 0,
						'default_value' => '',
						'placeholder' => '',
						'prepend' => '',
						'append' => '',
						'formatting' => 'html',
						'maxlength' => '',
          ),

					array (
						'key' => 'field_5b65c9d38f5bb',
						'label' => 'Expiry date',
						'name' => 'expiry_date',
						'type' => 'date_picker',
						'required' => 1,
						'date_format' => 'yy-mm-dd',
						'display_format' => 'dd/mm/yy',
						'first_day' => 1,
					),

					array (
						'key' => 'field_5b65ca008f5bc',
						'label' => 'Listing URL',
						'name' => 'listing_url',
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
						'key' => 'field_5b65ca008f5bd',
						'label' => 'Label(s)',
						'name' => 'job_labels',
						'type' => 'taxonomy',
            'taxonomy' => 'jr_joblabel',
						'field_type' => 'checkbox',
            'allow_term' => 0
					),


					array (
						'key' => 'field_5b71c19a7ae3c',
						'label' => 'Paid promotion',
						'name' => 'paid_promotion',
						'type' => 'true_false',
						'message' => '',
						'default_value' => 0,
					),

					array (
						'key' => 'field_5b71c1d77ae3d',
						'label' => 'Job description (preview)',
						'name' => 'job_description_preview',
						'type' => 'wysiwyg',
						'required' => 1,
						'conditional_logic' => array (
							'status' => 1,
							'rules' => array (
								array (
									'field' => 'field_5b71c19a7ae3c',
									'operator' => '==',
									'value' => '1',
								),
							),
							'allorany' => 'all',
						),
						'default_value' => '',
						'toolbar' => 'full',
						'media_upload' => 'no',
					),

					array (
						'key' => 'field_5b71c1d77ae3f',
						'label' => 'Job description (full)',
						'name' => 'job_description_full',
						'type' => 'wysiwyg',
						'required' => 1,
						'conditional_logic' => array (
							'status' => 1,
							'rules' => array (
								array (
									'field' => 'field_5b71c19a7ae3c',
									'operator' => '==',
									'value' => '1',
								),
							),
							'allorany' => 'all',
						),
						'default_value' => '',
						'toolbar' => 'full',
						'media_upload' => 'no',
					),

					array (
						'key' => 'field_5b71c2267ae3e',
						'label' => 'Company logo',
						'name' => 'company_logo',
						'type' => 'image',
						'instructions' => 'The logo of the company paying to promote this job',
						'required' => 1,
						'conditional_logic' => array (
							'status' => 1,
							'rules' => array (
								array (
									'field' => 'field_5b71c19a7ae3c',
									'operator' => '==',
									'value' => '1',
								),
							),
							'allorany' => 'all',
						),
						'save_format' => 'url',
						'preview_size' => 'thumbnail',
						'library' => 'all',
					),
				),

				'location' => array (
					array (
						array (
							'param' => 'post_type',
							'operator' => '==',
							'value' => 'jr_joblisting',
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
	 * Register job listing fields with ACF
	 *
	 * @since    1.0.0
	 */
	private function register_acf_fields_joblabels()
	{
		if(function_exists("register_field_group"))
		{
			register_field_group(array (
				'id' => 'acf_joblabels',
				'title' => 'Job labels',
				'fields' => array (
					array (
						'key' => 'field_5c75c99d8f5b8',
						'label' => 'Background colour',
						'name' => 'background_colour',
						'type' => 'text',
						'required' => 1,
						'default_value' => '',
						'placeholder' => 'Hex code e.g. #1d76db',
						'prepend' => '',
						'append' => '',
						'formatting' => 'html',
						'maxlength' => '',
					),
					array (
						'key' => 'field_5c75c99d8f5b9',
						'label' => 'Text colour',
						'name' => 'text_colour',
						'type' => 'text',
						'required' => 1,
						'default_value' => '#ffffff',
						'placeholder' => 'Hex code e.g. #ffffff',
						'prepend' => '',
						'append' => '',
						'formatting' => 'html',
						'maxlength' => '',
					),
				),

				'location' => array (
					array (
						array (
							'param' => 'ef_taxonomy',
							'operator' => '==',
							'value' => 'jr_joblabel',
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
			'employer' =>  __( 'Employer' ),
			'location' =>  __( 'Location' ),
			'salary' =>  __( 'Salary' ),
			'citation' =>  __( 'Citation' ),
			'expiry_date' =>  __( 'Expiry date' ),
			'paid_promotion' =>  __( 'Promoted?' ),
			'date' =>  $columns['date'],
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
			case 'employer' :
				echo $fields['employer'];
				break;
			case 'location' :
				echo $fields['location'];
				break;
			case 'expiry_date' :
				echo $fields['expiry_date'];
				break;
			case 'salary' :
				echo $fields['salary'];
				break;
			case 'citation' :
				echo $fields['citation'];
				break;
      case 'paid_promotion' :
        if ($fields['paid_promotion']) {
          echo 'Yes';
        } else {
          echo 'No';
        }
				break;
    }
	}

	/**
	 * Register custom /jr/v1/jobs REST endpoints
	 *
	 * @since    1.3.0
	 */
  public function add_custom_rest_endpoints() {
    $this->add_custom_jobs_endpoint();
    $this->add_custom_job_labels_endpoint();
  }

	/**
	 * Register custom /jr/v1/jobs REST endpoint
	 *
	 * @since    1.0.0
	 */
	public function add_custom_jobs_endpoint() {

		$jr_jobs_endpoint = function ( $request ) {

			$args = array(
				'post_type' => 'jr_joblisting',
				'posts_per_page' => -1,
			);

			// The user of the API may request only jobs that expire on or after a given date
			$dateFilter = $request->get_param( 'expire_after' );

			if ( isset( $dateFilter ) ) {
				$args['meta_query'] = array(
					'relation' => 'AND',
					array(
						'key' => 'expiry_date',
						'value' => $dateFilter,
						'type' => 'DATETIME',
						'compare' => '>='
					)
				);
			};

			// The basic get_posts response includes lots of extra fields from WP...
			$jobsData = get_posts( $args );

			$jobs = array();

			foreach ( $jobsData as $key => $jobData ) {

				$jobID = $jobData->ID;

				// ... so we pick the ones we want
				$job = array(
					'title' => $jobData->post_title,
					'link' => get_permalink( $jobID ),
					'params' => $params
				);

				$customFieldsData = get_fields( $jobID );

				$customFieldsToInclude = array(
					'employer',
					'location',
					'salary',
					'citation',
					'citation_url',
					'expiry_date',
					'listing_url',
          'job_labels',
					'paid_promotion',
					'job_description_preview',
					'company_logo',
				);

        foreach ( $customFieldsToInclude as $cf ) {
          $fieldData = $customFieldsData[$cf];
          if ($cf == 'expiry_date') {
            $fieldData = strtotime( $fieldData ) * 1000;
          }
					$job[$cf] = $fieldData;

				};

				$jobs[$key] = $job;
			}

			return $jobs;
		};

		register_rest_route( 'jr/v1', '/jobs/', array(
			'methods' => 'GET',
			'callback' => $jr_jobs_endpoint
		));
	}

	/**
	 * Register custom /jr/v1/jobs/labels REST endpoint
	 *
	 * @since    1.3.0
	 */
	public function add_custom_job_labels_endpoint() {

		$jr_job_labels_endpoint = function ( $request ) {

			$args = array(
				'taxonomy' => 'jr_joblabel',
				//'posts_per_page' => -1,
        'hide_empty' => false
			);

			// The basic get_posts response includes lots of extra fields from WP...
			$labelsData = get_terms( $args );

			$labels = array();

			foreach ( $labelsData as $key => $labelData ) {

        $taxonomyWithId = $labelData->taxonomy . '_' . $labelData->term_id;
        $customFieldsData = get_fields($taxonomyWithId);

        $label = array(
          'id' => $labelData->term_id,
          'text' => $labelData->name,
        );

				$customFieldsToInclude = array(
					'background_colour',
					'text_colour',
				);

        foreach ( $customFieldsToInclude as $cf ) {
          $fieldData = $customFieldsData[$cf];
					$label[$cf] = $fieldData;
				};

				$labels[$key] = $label;
			}

      return $labels;
		};

		register_rest_route( 'jr/v1', '/jobs/labels/', array(
			'methods' => 'GET',
			'callback' => $jr_job_labels_endpoint
		));
	}
}
