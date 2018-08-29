<?php get_header(); ?>

<?php 
  $post = get_post();
  $postID = $post->ID;

  $authorID = $post->post_author;

  $title = $post->post_title;
  $employer = get_field('employer');
  $salary = get_field('salary');
  $location = get_field('location');
  $expiry_date = get_field('expiry_date');
  $listing_url = get_field('listing_url');
  $logo = get_field('company_logo');
  $description = get_field('job_description_full');
?>

<div id="primary">
  <div id="content">
    <section class="jr_joblisting type-jr_joblisting">
      <article>
        <header class="entry-header">
          
          <h2 class="entry-title jr-job-title"><?php echo $title . ', ' . $employer; ?></h2>
      
          <div class="entry-meta clearfix">
            <div class="by-author vcard author">
              <span class="fn">
              <a href="<?php echo get_author_posts_url( $authorID ); ?>">
                <?php echo get_author_name($authorID); ?>
              </a>
              </span>
            </div>

            <div class="date updated">
              <a href="<?php the_permalink(); ?>" title="<?php echo esc_attr( get_the_time() ); ?>">
                Posted <?php the_time( get_option( 'date_format' ) ); ?>
              </a>
            </div>
            
          </div>
      
        </header>
    
        <div class="entry-content clearfix">
          
          <div class="jr-job-description"><?php echo $location . ' - ' . $salary; ?></div>
          
          <div class="jr-job-expiry"><?php echo 'Closes ' . $expiry_date; ?></div>
          
          <div class="jr-company-logo">
            <img src="<?php echo $logo; ?>" alt="<?php echo $employer; ?>" />
          </div>
        
          <div class="jr-job-description"><?php echo the_field('job_description_full'); ?></div>
          
          <div class="jr-apply-button">
            <a title="Apply now" href="<?php echo $listing_url; ?>" target="_blank">
              <span>Apply now</span>
            </a>
          </div>

        </div>
      </article>
    </section>
  </div>
</div>

<div class="secondary">
  <!-- Sidebar -->
</div>

<?php get_footer(); ?>
