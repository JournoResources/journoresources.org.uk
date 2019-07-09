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

  $formattedDate = date( 'd/m/Y', strtotime( $expiry_date ) );
  $formattedToday = date( 'd/m/Y' );

  $isToday = $formattedDate == $formattedToday;

  $labelIds = get_field('job_labels');
  $labels = array();
  foreach ($labelIds as $labelId) {
    $labelData = get_term($labelId);
    $labelFields = get_fields($labelData->taxonomy . '_' . $labelId);

    $label = array();
    $label['text'] = $labelData->name;
    $label['background_colour'] = $labelFields['background_colour'];
    $label['text_colour'] = $labelFields['text_colour'];
    $labels[$labelId] = $label;
  }
?>

<!-- Google Jobs -->
<script type="application/ld+json">
  {
    "@context": "http://schema.org/",
    "@type": "JobPosting",
    "description": "<?php echo $description; ?>",
    "datePosted": "<?php echo get_the_date('d/m/Y'); ?>",
    "hiringOrganization": "<?php echo $employer; ?>",
    "jobLocation": {
      "@type": "Place",
      "address": "<?php echo $location; ?>"
    },
    "title": "<?php echo $title; ?>",
    "validThrough": "<?php echo $formattedDate; ?>"
  }
</script>

<style>
  .page-title {
    display: none;
  }
</style>

<div id="primary">
  <div id="content">
    <section class="jr_joblisting type-jr_joblisting">
      <article id="jr-single-job">
        <header class="entry-header">
          
          <h2 class="entry-title jr-job-title"><?php echo $title . ', ' . $employer; ?></h2>
      
          <div class="entry-meta clearfix">
            <div class="by-author vcard author">
              <span class="fn">
              <a href="<?php echo get_author_posts_url( $authorID ); ?>">
                Posted by <?php echo get_author_name($authorID); ?>
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
          
          <div class="jr-job-location">
            <strong>Location: </strong> <?php echo $location ?>
          </div>

          <div class="jr-job-salary">
            <strong>Salary details: </strong> <?php echo $salary ?>
          </div>
          
          <div class="jr-job-expiry">
            <?php
            if ($isToday) {
              echo '<strong>Closes today</strong>';
            } else {
              echo '<strong>Closes: </strong>' . $formattedDate;
            } ?>
          </div>

          <div class="jr-job-labels-container">
            <ul class="jr-job-labels">
              <?php foreach ($labels as $label) {
                $color = str_replace( '#', '', $label['text_colour'] );
                $bgColor = str_replace( '#', '', $label['background_colour'] );
              ?>
                <li class="label" style="color: #<?php echo $color; ?>; background-color: #<?php echo $bgColor; ?>;"
                >
                  <?php echo $label['text']; ?>
                </li>
              <?php } ?>
            </ul>
          </div>

          <hr class="jr-divider" />
          
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

<div id="secondary">
  <?php get_sidebar( 'right' ); ?>
</div>

<?php get_footer(); ?>
